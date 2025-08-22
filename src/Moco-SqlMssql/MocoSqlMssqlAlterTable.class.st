"
Represents an ALTER TABLE statement in a Microsoft SQL Server database.
"
Class {
	#name : 'MocoSqlMssqlAlterTable',
	#superclass : 'Object',
	#instVars : [
		'table',
		'statement'
	],
	#category : 'Moco-SqlMssql-Model',
	#package : 'Moco-SqlMssql',
	#tag : 'Model'
}

{ #category : 'initialization' }
MocoSqlMssqlAlterTable >> initialize [
	super initialize.
	
	table := ''.
	statement := ''
]

{ #category : 'printing' }
MocoSqlMssqlAlterTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: table);
		nextPutAll: ' ';
		nextPutAll: statement;
		nextPutAll: ';'
]

{ #category : 'printing' }
MocoSqlMssqlAlterTable >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : 'accessing' }
MocoSqlMssqlAlterTable >> statement [
	^ statement
]

{ #category : 'accessing' }
MocoSqlMssqlAlterTable >> statement: aString [
	statement := aString 
]

{ #category : 'accessing' }
MocoSqlMssqlAlterTable >> table [
	^ table
]

{ #category : 'accessing' }
MocoSqlMssqlAlterTable >> table: aString [
	table := aString
]
