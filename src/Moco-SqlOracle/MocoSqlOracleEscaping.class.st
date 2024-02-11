"
String escaping utils for Oracle SQL.
"
Class {
	#name : #MocoSqlOracleEscaping,
	#superclass : #Object,
	#category : #'Moco-SqlOracle-Utils'
}

{ #category : #'as yet unclassified' }
MocoSqlOracleEscaping class >> escapeTableName: aString [
	^ '"' , aString , '"'
]
