"
Resolves column data types for the MySQL relational database.
"
Class {
	#name : #MocoSqlMysqlDataTypeResolver,
	#superclass : #MocoRdbDataTypeVisitor,
	#instVars : [
		'typeDeclaration'
	],
	#classVars : [
		'Instance'
	],
	#category : #'Moco-SqlMysql-Utils'
}

{ #category : #'instance creation' }
MocoSqlMysqlDataTypeResolver class >> instance [
	"Returns a singleton instance of this class."
	
	Instance ifNotNil: [ ^ Instance ].
	
	Instance := self new.
	
	^ Instance
]

{ #category : #accessing }
MocoSqlMysqlDataTypeResolver >> typeDeclaration [
	^ typeDeclaration
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitBlob: aMocoRdbTypeBlob [
	typeDeclaration := 'BLOB'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitBoolean: aMocoRdbTypeBoolean [
	typeDeclaration := 'BOOLEAN'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitCharacter: aMocoRdbTypeCharacter [
	typeDeclaration := 'CHAR(1)'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitDate: aMocoRdbTypeDate [
	typeDeclaration := 'DATE'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitDateTime: aMocoRdbTypeDateTime [
	typeDeclaration := 'DATETIME'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitDouble: aMocoRdbTypeDouble [
	typeDeclaration := 'FLOAT(53)'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitInteger: aMocoRdbTypeInteger [
	typeDeclaration := 'BIGINT'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitTimestamp: aMocoRdbTypeTimestamp [
	typeDeclaration := 'TIMESTAMP'
]

{ #category : #visiting }
MocoSqlMysqlDataTypeResolver >> visitVarchar: aMocoRdbTypeVarchar [
	aMocoRdbTypeVarchar
		ifNil: [ typeDeclaration := 'TEXT' ]
		ifNotNil: [ typeDeclaration := 'VARCHAR(' , (aMocoRdbTypeVarchar length asString) , ')' ]
]
