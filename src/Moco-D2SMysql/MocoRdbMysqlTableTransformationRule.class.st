"
Transforms table definition into a CREATE TABLE statement.
"
Class {
	#name : 'MocoRdbMysqlTableTransformationRule',
	#superclass : 'MocoTransformationRule',
	#instVars : [
		'typeResolver'
	],
	#category : 'Moco-D2SMysql-Rule',
	#package : 'Moco-D2SMysql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMysqlTableTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbMysqlTableTransformationRule.
	
	tables do: [ :each |
		| statement |
		statement := self toCreateTable: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbMysqlTableTransformationRule
	]
]

{ #category : 'initialization' }
MocoRdbMysqlTableTransformationRule >> initialize [
	super initialize.
	
	typeResolver := MocoSqlMysqlDataTypeResolver instance
]

{ #category : 'accessing' }
MocoRdbMysqlTableTransformationRule >> priority [
	^ 100
]

{ #category : 'private - transforming' }
MocoRdbMysqlTableTransformationRule >> toColumnDefinition: aMocoRdbColumn [
	"Returns a table column definition."
	
	| str |
	str := String new writeStream.
	
	str nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn name)).
	
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
MocoRdbMysqlTableTransformationRule >> toCreateTable: aMocoRdbTable [
	"Returns a CREATE TABLE statement for the given table."
	
	| sql |
	sql := MocoSqlMysqlCreateTable new.
	sql name: aMocoRdbTable name.
	
	sql columnDefinitions addAll: (aMocoRdbTable columns collect: [ :each | self toColumnDefinition: each ]).
	
	(sql constraintDefinitions)
		addAll: (self toPrimaryKeyDefinitions: aMocoRdbTable);
		addAll: (self toUniqueKeyDefinitions: aMocoRdbTable).
	
	^ sql
]

{ #category : 'private - transforming' }
MocoRdbMysqlTableTransformationRule >> toPrimaryKeyDefinitions: aMocoRdbTable [
	"Returns PRIMARY KEY constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ].
	
	^ keys collect: [ :each |
		(MocoSqlMysqlEscaping escapeName: (each name)) , ' PRIMARY KEY (' , (', ' join: (each columns collect: [ :c | MocoSqlMysqlEscaping escapeName: (c name) ])) , ')'
	]
]

{ #category : 'private - transforming' }
MocoRdbMysqlTableTransformationRule >> toTypeDeclaration: aMocoRdbDataType [
	"Returns column type declaration for the given data type."
	
	aMocoRdbDataType accept: typeResolver.
	
	^ typeResolver typeDeclaration
]

{ #category : 'private - transforming' }
MocoRdbMysqlTableTransformationRule >> toUniqueKeyDefinitions: aMocoRdbTable [
	"Returns UNIQUE constraint definitions."
	
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbUniqueKey ].
	
	^ keys collect: [ :each |
		(MocoSqlMysqlEscaping escapeName: (each name)) , ' UNIQUE (' , (', ' join: (each columns collect: [ :c | MocoSqlMysqlEscaping escapeName: (c name) ])) , ')'
	]
]
