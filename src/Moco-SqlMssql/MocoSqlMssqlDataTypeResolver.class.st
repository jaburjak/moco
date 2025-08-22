"
Resolves column data types for the Microsoft SQL Server relational database.
"
Class {
	#name : 'MocoSqlMssqlDataTypeResolver',
	#superclass : 'MocoRdbDataTypeVisitor',
	#instVars : [
		'typeDeclaration'
	],
	#classVars : [
		'Instance'
	],
	#category : 'Moco-SqlMssql-Utils',
	#package : 'Moco-SqlMssql',
	#tag : 'Utils'
}

{ #category : 'instance creation' }
MocoSqlMssqlDataTypeResolver class >> instance [
	"Returns a singleton instance of this class."
	
	(Instance isNotNil and: [ Instance isKindOf: self class ]) ifTrue: [ ^ Instance ].
	
	Instance := self new.
	
	^ Instance
]

{ #category : 'accessing' }
MocoSqlMssqlDataTypeResolver >> typeDeclaration [
	^ typeDeclaration
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitBlob: aMocoRdbTypeBlob [
	typeDeclaration := 'VARBINARY(MAX)'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitBoolean: aMocoRdbTypeBoolean [
	typeDeclaration := 'TINYINT'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitCharacter: aMocoRdbTypeCharacter [
	typeDeclaration := 'NCHAR(1)'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitDate: aMocoRdbTypeDate [
	typeDeclaration := 'DATE'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitDateTime: aMocoRdbTypeDateTime [
	typeDeclaration := 'DATETIME2(0)'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitDouble: aMocoRdbTypeDouble [
	typeDeclaration := 'FLOAT(53)'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitInteger: aMocoRdbTypeInteger [
	typeDeclaration := 'BIGINT'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitTimestamp: aMocoRdbTypeTimestamp [
	typeDeclaration := 'DATETIME'
]

{ #category : 'visiting' }
MocoSqlMssqlDataTypeResolver >> visitVarchar: aMocoRdbTypeVarchar [
	aMocoRdbTypeVarchar length
		ifNil: [ typeDeclaration := 'NVARCHAR(MAX)' ]
		ifNotNil: [ typeDeclaration := 'NVARCHAR(' , (aMocoRdbTypeVarchar length asString) , ')' ]
]
