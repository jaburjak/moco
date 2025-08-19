"
Transforms table definition into a CREATE TABLE statement.
"
Class {
	#name : 'MocoRdbPostgresqlTableTransformationRule',
	#superclass : 'MocoTransformationRule',
	#instVars : [
		'typeResolver'
	],
	#category : 'Moco-D2SPostgresql-Rule',
	#package : 'Moco-D2SPostgresql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbPostgresqlTableTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbPostgresqlTableTransformationRule.
	
	tables do: [ :each |
		| statement |
		statement := self toCreateTable: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbPostgresqlTableTransformationRule
	]
]

{ #category : 'initialization' }
MocoRdbPostgresqlTableTransformationRule >> initialize [
	super initialize.
	
	typeResolver := MocoSqlPostgresqlDataTypeResolver instance
]

{ #category : 'accessing' }
MocoRdbPostgresqlTableTransformationRule >> priority [
	^ 100
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlTableTransformationRule >> toColumnDefinition: aMocoRdbColumn [
	"Returns a table column definition."
	
	| str |
	str := String new writeStream.
	
	str nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name)).
	
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
MocoRdbPostgresqlTableTransformationRule >> toCreateTable: aMocoRdbTable [
	"Returns a CREATE TABLE statement for the given table."
	
	| sql |
	sql := MocoSqlPostgresqlCreateTable new.
	sql name: aMocoRdbTable name.
	
	sql columnDefinitions addAll: (aMocoRdbTable columns collect: [ :each | self toColumnDefinition: each ]).
	
	(sql constraintDefinitions)
		addAll: (self toPrimaryKeyDefinitions: aMocoRdbTable);
		addAll: (self toUniqueKeyDefinitions: aMocoRdbTable).
	
	^ sql
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlTableTransformationRule >> toPrimaryKeyDefinitions: aMocoRdbTable [
	"Returns PRIMARY KEY constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ].
	
	^ keys collect: [ :each |
		(MocoSqlPostgresqlEscaping escapeName: (each name)) , ' PRIMARY KEY (' , (', ' join: (each columns collect: [ :c | MocoSqlPostgresqlEscaping escapeName: (c name) ])) , ')'
	]
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlTableTransformationRule >> toTypeDeclaration: aMocoRdbDataType [
	"Returns column type declaration for the given data type."
	
	aMocoRdbDataType accept: typeResolver.
	
	^ typeResolver typeDeclaration
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlTableTransformationRule >> toUniqueKeyDefinitions: aMocoRdbTable [
	"Returns UNIQUE constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbUniqueKey ].
	
	^ keys collect: [ :each |
		(MocoSqlPostgresqlEscaping escapeName: (each name)) , ' UNIQUE (' , (', ' join: (each columns collect: [ :c | MocoSqlPostgresqlEscaping escapeName: (c name) ])) , ')'
	]
]
