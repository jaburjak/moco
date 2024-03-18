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
	^ '''' , aString , ''''
]

{ #category : #transforming }
MocoSqlOracleEscaping class >> escapeName: aString [
	^ '"' , aString , '"'
]
