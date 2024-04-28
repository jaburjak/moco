"
String escaping utils for Oracle SQL.
"
Class {
	#name : #MocoSqlOracleEscaping,
	#superclass : #Object,
	#category : #'Moco-SqlOracle-Utils'
}

{ #category : #transforming }
MocoSqlOracleEscaping class >> escapeLiteral: aString [
	^ '''' , (aString copyReplaceAll: '''' with: '''''') , ''''
]

{ #category : #transforming }
MocoSqlOracleEscaping class >> escapeName: aString [
	^ '"' , (aString copyReplaceAll: '"' with: '' ) , '"'
]
