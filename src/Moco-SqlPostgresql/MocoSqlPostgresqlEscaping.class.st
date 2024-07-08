"
String escaping utils for PostgreSQL.
"
Class {
	#name : #MocoSqlPostgresqlEscaping,
	#superclass : #Object,
	#category : #'Moco-SqlPostgresql-Utils'
}

{ #category : #transforming }
MocoSqlPostgresqlEscaping class >> escapeLiteral: aString [
	^ '''' , (aString copyReplaceAll: '''' with: '''''') , ''''
]

{ #category : #transforming }
MocoSqlPostgresqlEscaping class >> escapeName: aString [
	^ '"' , (aString copyReplaceAll: '"' with: '' ) , '"'
]
