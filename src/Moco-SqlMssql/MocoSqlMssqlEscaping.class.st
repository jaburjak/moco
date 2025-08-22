"
String escaping utils for Microsoft SQL Server.
"
Class {
	#name : 'MocoSqlMssqlEscaping',
	#superclass : 'Object',
	#category : 'Moco-SqlMssql-Utils',
	#package : 'Moco-SqlMssql',
	#tag : 'Utils'
}

{ #category : 'transforming' }
MocoSqlMssqlEscaping class >> escapeLiteral: aString [
	^ '''' , (aString copyReplaceAll: '''' with: '\''') , ''''
]

{ #category : 'transforming' }
MocoSqlMssqlEscaping class >> escapeName: aString [
	^ '[' , (aString copyReplaceAll: ']' with: ']]' ) , ']'
]
