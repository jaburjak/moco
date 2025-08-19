"
Represents an ALTER TABLE statement in a MySQL database.
"
Class {
	#name : 'MocoSqlMysqlAlterTable',
	#superclass : 'Object',
	#instVars : [
		'table',
		'statement'
	],
	#category : 'Moco-SqlMysql-Model',
	#package : 'Moco-SqlMysql',
	#tag : 'Model'
}

{ #category : 'initialization' }
MocoSqlMysqlAlterTable >> initialize [
	super initialize.
	
	table := ''.
	statement := ''
]

{ #category : 'printing' }
MocoSqlMysqlAlterTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: table);
		nextPutAll: ' ';
		nextPutAll: statement;
		nextPutAll: ';'
]

{ #category : 'printing' }
MocoSqlMysqlAlterTable >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : 'accessing' }
MocoSqlMysqlAlterTable >> statement [
	^ statement
]

{ #category : 'accessing' }
MocoSqlMysqlAlterTable >> statement: aString [
	statement := aString 
]

{ #category : 'accessing' }
MocoSqlMysqlAlterTable >> table [
	^ table
]

{ #category : 'accessing' }
MocoSqlMysqlAlterTable >> table: aString [
	table := aString
]
