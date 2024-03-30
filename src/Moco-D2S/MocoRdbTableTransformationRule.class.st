"
Transforms table definition into a CREATE TABLE statement.
"
Class {
	#name : #MocoRdbTableTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'typeResolver'
	],
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbTableTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbTableTransformationRule.
	
	tables do: [ :each |
		| statement |
		statement := self toCreateTable: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbTableTransformationRule
	]
]

{ #category : #initialization }
MocoRdbTableTransformationRule >> initialize [
	super initialize.
	
	typeResolver := MocoSqlOracleDataTypeResolver instance
]

{ #category : #accessing }
MocoRdbTableTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoRdbTableTransformationRule >> toColumnDefinition: aMocoRdbColumn [
	"Returns a table column definition."
	
	| str |
	str := String new writeStream.
	
	str nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name)).
	
	aMocoRdbColumn type ifNotNil: [
		str
			nextPutAll: ' ';
			nextPutAll: (self toTypeDeclaration: (aMocoRdbColumn type)).
		
		(aMocoRdbColumn nullable) ifFalse: [
			str nextPutAll: ' NOT NULL'
		]
	].
		
	^ str contents
]

{ #category : #'private - transforming' }
MocoRdbTableTransformationRule >> toCreateTable: aMocoRdbTable [
	"Returns a CREATE TABLE statement for the given table."
	
	| sql |
	sql := MocoSqlOracleCreateTable new.
	sql name: aMocoRdbTable name.
	
	sql columnDefinitions addAll: (aMocoRdbTable columns collect: [ :each | self toColumnDefinition: each ]).
	
	(sql constraintDefinitions)
		addAll: (self toPrimaryKeyDefinitions: aMocoRdbTable);
		addAll: (self toUniqueKeyDefinitions: aMocoRdbTable).
	
	^ sql
]

{ #category : #'private - transforming' }
MocoRdbTableTransformationRule >> toPrimaryKeyDefinitions: aMocoRdbTable [
	"Returns PRIMARY KEY constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ].
	
	^ keys collect: [ :each |
		(MocoSqlOracleEscaping escapeName: (each name)) , ' PRIMARY KEY (' , (', ' join: (each columns collect: [ :c | MocoSqlOracleEscaping escapeName: (c name) ])) , ')'
	]
]

{ #category : #'private - transforming' }
MocoRdbTableTransformationRule >> toTypeDeclaration: aMocoRdbDataType [
	"Returns column type declaration for the given data type."
	
	aMocoRdbDataType accept: typeResolver.
	
	^ typeResolver typeDeclaration
]

{ #category : #'private - transforming' }
MocoRdbTableTransformationRule >> toUniqueKeyDefinitions: aMocoRdbTable [
	"Returns UNIQUE constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbUniqueKey ].
	
	^ keys collect: [ :each |
		(MocoSqlOracleEscaping escapeName: (each name)) , ' UNIQUE (' , (', ' join: (each columns collect: [ :c | MocoSqlOracleEscaping escapeName: (c name) ])) , ')'
	]
]
