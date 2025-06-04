"
Represents an input argument for a CREATE PROCEDURE statement.
"
Class {
	#name : #MocoSqlMysqlCreateProcedureInput,
	#superclass : #Object,
	#instVars : [
		'name',
		'type'
	],
	#category : #'Moco-SqlMysql-Model'
}

{ #category : #accessing }
MocoSqlMysqlCreateProcedureInput >> name [
	^ name
]

{ #category : #accessing }
MocoSqlMysqlCreateProcedureInput >> name: aString [
	name := aString
]

{ #category : #printing }
MocoSqlMysqlCreateProcedureInput >> printSqlTo: aStream [
	aStream
		nextPutAll: (MocoSqlMysqlEscaping escapeName: name);
		nextPutAll: ' ';
		nextPutAll: type
]

{ #category : #accessing }
MocoSqlMysqlCreateProcedureInput >> type [
	^ type
]

{ #category : #accessing }
MocoSqlMysqlCreateProcedureInput >> type: aString [
	type := aString
]
