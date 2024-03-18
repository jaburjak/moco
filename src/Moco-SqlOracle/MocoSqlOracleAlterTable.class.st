"
Represents an ALTER TABLE statement in an Oracle relational database.
"
Class {
	#name : #MocoSqlOracleAlterTable,
	#superclass : #Object,
	#instVars : [
		'table',
		'statement'
	],
	#category : #'Moco-SqlOracle-Model'
}

{ #category : #initialization }
MocoSqlOracleAlterTable >> initialize [
	super initialize.
	
	table := ''.
	statement := ''
]

{ #category : #printing }
MocoSqlOracleAlterTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'ALTER TABLE ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: table);
		nextPutAll: ' ';
		nextPutAll: statement;
		nextPutAll: ';'
]

{ #category : #printing }
MocoSqlOracleAlterTable >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : #accessing }
MocoSqlOracleAlterTable >> statement [
	^ statement
]

{ #category : #accessing }
MocoSqlOracleAlterTable >> statement: aString [
	statement := aString 
]

{ #category : #accessing }
MocoSqlOracleAlterTable >> table [
	^ table
]

{ #category : #accessing }
MocoSqlOracleAlterTable >> table: aString [
	table := aString
]
