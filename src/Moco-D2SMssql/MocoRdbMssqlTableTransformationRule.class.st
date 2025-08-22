"
Transforms table definition into a CREATE TABLE statement.
"
Class {
	#name : 'MocoRdbMssqlTableTransformationRule',
	#superclass : 'MocoTransformationRule',
	#instVars : [
		'typeResolver'
	],
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlTableTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbMssqlTableTransformationRule.
	
	tables do: [ :each |
		| statement |
		statement := self toCreateTable: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbMssqlTableTransformationRule
	]
]

{ #category : 'initialization' }
MocoRdbMssqlTableTransformationRule >> initialize [
	super initialize.
	
	typeResolver := MocoSqlMssqlDataTypeResolver instance
]

{ #category : 'accessing' }
MocoRdbMssqlTableTransformationRule >> priority [
	^ 100
]

{ #category : 'private - transforming' }
MocoRdbMssqlTableTransformationRule >> toColumnDefinition: aMocoRdbColumn [
	"Returns a table column definition."
	
	| str |
	str := String new writeStream.
	
	str nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbColumn name)).
	
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

{ #category : 'private - transforming' }
MocoRdbMssqlTableTransformationRule >> toCreateTable: aMocoRdbTable [
	"Returns a CREATE TABLE statement for the given table."
	
	| sql |
	sql := MocoSqlMssqlCreateTable new.
	sql name: aMocoRdbTable name.
	
	sql columnDefinitions addAll: (aMocoRdbTable columns collect: [ :each | self toColumnDefinition: each ]).
	
	(sql constraintDefinitions)
		addAll: (self toPrimaryKeyDefinitions: aMocoRdbTable);
		addAll: (self toUniqueKeyDefinitions: aMocoRdbTable).
	
	^ sql
]

{ #category : 'private - transforming' }
MocoRdbMssqlTableTransformationRule >> toPrimaryKeyDefinitions: aMocoRdbTable [
	"Returns PRIMARY KEY constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ].
	
	^ keys collect: [ :each |
		(MocoSqlMssqlEscaping escapeName: (each name)) , ' PRIMARY KEY (' , (', ' join: (each columns collect: [ :c | MocoSqlMssqlEscaping escapeName: (c name) ])) , ')'
	]
]

{ #category : 'private - transforming' }
MocoRdbMssqlTableTransformationRule >> toTypeDeclaration: aMocoRdbDataType [
	"Returns column type declaration for the given data type."
	
	aMocoRdbDataType accept: typeResolver.
	
	^ typeResolver typeDeclaration
]

{ #category : 'private - transforming' }
MocoRdbMssqlTableTransformationRule >> toUniqueKeyDefinitions: aMocoRdbTable [
	"Returns UNIQUE constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbUniqueKey ].
	
	^ keys collect: [ :each |
		(MocoSqlMssqlEscaping escapeName: (each name)) , ' UNIQUE (' , (', ' join: (each columns collect: [ :c | MocoSqlMssqlEscaping escapeName: (c name) ])) , ')'
	]
]
