"
Represents an ALTER TABLE statement in a PostgreSQL database.
"
Class {
	#name : #MocoSqlPostgresqlAlterTable,
	#superclass : #Object,
	#instVars : [
		'table',
		'statement'
	],
	#category : #'Moco-SqlPostgresql-Model'
}

{ #category : #initialization }
MocoSqlPostgresqlAlterTable >> initialize [
	super initialize.
	
	table := ''.
	statement := ''
]

{ #category : #printing }
MocoSqlPostgresqlAlterTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: table);
		nextPutAll: ' ';
		nextPutAll: statement;
		nextPutAll: ';'
]

{ #category : #printing }
MocoSqlPostgresqlAlterTable >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : #accessing }
MocoSqlPostgresqlAlterTable >> statement [
	^ statement
]

{ #category : #accessing }
MocoSqlPostgresqlAlterTable >> statement: aString [
	statement := aString 
]

{ #category : #accessing }
MocoSqlPostgresqlAlterTable >> table [
	^ table
]

{ #category : #accessing }
MocoSqlPostgresqlAlterTable >> table: aString [
	table := aString
]
