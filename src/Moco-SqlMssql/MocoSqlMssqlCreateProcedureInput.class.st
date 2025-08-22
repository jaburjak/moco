"
Represents an input argument for a CREATE PROCEDURE statement.
"
Class {
	#name : 'MocoSqlMssqlCreateProcedureInput',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type'
	],
	#category : 'Moco-SqlMssql-Model',
	#package : 'Moco-SqlMssql',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedureInput >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedureInput >> name: aString [
	name := aString
]

{ #category : 'printing' }
MocoSqlMssqlCreateProcedureInput >> printSqlTo: aStream [
	aStream
		nextPutAll: '@';
		nextPutAll: name;
		nextPutAll: ' ';
		nextPutAll: type
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedureInput >> type [
	^ type
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedureInput >> type: aString [
	type := aString
]
