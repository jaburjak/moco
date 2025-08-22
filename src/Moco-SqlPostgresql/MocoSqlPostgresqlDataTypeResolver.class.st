"
Resolves column data types for a PostgreSQL relational database.
"
Class {
	#name : 'MocoSqlPostgresqlDataTypeResolver',
	#superclass : 'MocoRdbDataTypeVisitor',
	#instVars : [
		'typeDeclaration'
	],
	#classVars : [
		'Instance'
	],
	#category : 'Moco-SqlPostgresql-Utils',
	#package : 'Moco-SqlPostgresql',
	#tag : 'Utils'
}

{ #category : 'instance creation' }
MocoSqlPostgresqlDataTypeResolver class >> instance [
	"Returns a singleton instance of this class."
	
	(Instance isNotNil and: [ Instance isKindOf: self class ]) ifTrue: [ ^ Instance ].
	
	Instance := self new.
	
	^ Instance
]

{ #category : 'accessing' }
MocoSqlPostgresqlDataTypeResolver >> typeDeclaration [
	^ typeDeclaration
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitBlob: aMocoRdbTypeBlob [
	typeDeclaration := 'BYTEA'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitBoolean: aMocoRdbTypeBoolean [
	typeDeclaration := 'BOOLEAN'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitCharacter: aMocoRdbTypeCharacter [
	typeDeclaration := 'CHAR(1)'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitDate: aMocoRdbTypeDate [
	typeDeclaration := 'DATE'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitDateTime: aMocoRdbTypeDateTime [
	typeDeclaration := 'TIMESTAMP(0)'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitDouble: aMocoRdbTypeDouble [
	typeDeclaration := 'FLOAT(53)'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitInteger: aMocoRdbTypeInteger [
	typeDeclaration := 'BIGINT'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitTimestamp: aMocoRdbTypeTimestamp [
	typeDeclaration := 'TIMESTAMP(0)'
]

{ #category : 'visiting' }
MocoSqlPostgresqlDataTypeResolver >> visitVarchar: aMocoRdbTypeVarchar [
	aMocoRdbTypeVarchar length
		ifNil: [ typeDeclaration := 'TEXT' ]
		ifNotNil: [ typeDeclaration := 'VARCHAR(' , (aMocoRdbTypeVarchar length asString) , ')' ]
]
