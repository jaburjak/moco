"
String escaping utils for PostgreSQL.
"
Class {
	#name : #MocoSqlMysqlEscaping,
	#superclass : #Object,
	#category : #'Moco-SqlMysql-Utils'
}

{ #category : #transforming }
MocoSqlMysqlEscaping class >> escapeLiteral: aString [
	^ '"' , (aString copyReplaceAll: '"' with: '\"') , '"'
]

{ #category : #transforming }
MocoSqlMysqlEscaping class >> escapeName: aString [
	^ '`' , (aString copyReplaceAll: '`' with: '' ) , '`'
]
