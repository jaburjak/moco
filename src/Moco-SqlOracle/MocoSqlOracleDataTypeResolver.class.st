"
Resolves column data type definitions for an Oracle relational database.
"
Class {
	#name : #MocoSqlOracleDataTypeResolver,
	#superclass : #MocoRdbDataTypeVisitor,
	#instVars : [
		'typeDeclaration'
	],
	#classVars : [
		'Instance'
	],
	#category : #'Moco-SqlOracle-Utils'
}

{ #category : #'instance creation' }
MocoSqlOracleDataTypeResolver class >> instance [
	"Returns a singleton instance of this class."
	
	Instance ifNotNil: [ ^ Instance ].
	
	Instance := self new.
	
	^ Instance
]

{ #category : #accessing }
MocoSqlOracleDataTypeResolver >> typeDeclaration [
	^ typeDeclaration
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitBlob: aMocoRdbTypeBlob [
	typeDeclaration := 'BLOB'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitBoolean: aMocoRdbTypeBoolean [
	typeDeclaration := 'CHAR(1 BYTE)'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitCharacter: aMocoRdbTypeCharacter [
	typeDeclaration := 'CHAR(1 CHAR)'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitDate: aMocoRdbTypeDate [
	typeDeclaration := 'DATE'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitDateTime: aMocoRdbTypeDateTime [
	typeDeclaration := 'DATE'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitDouble: aMocoRdbTypeDouble [
	typeDeclaration := 'FLOAT(126)'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitInteger: aMocoRdbTypeInteger [
	typeDeclaration := 'NUMBER(38)'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitTimestamp: aMocoRdbTypeTimestamp [
	typeDeclaration := 'TIMESTAMP(0)'
]

{ #category : #visiting }
MocoSqlOracleDataTypeResolver >> visitVarchar: aMocoRdbTypeVarchar [
	typeDeclaration := 'VARCHAR2(' , (aMocoRdbTypeVarchar length asString) , ')'
]
