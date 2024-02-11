"
Represents a CREATE TABLE statement in an Oracle database.
"
Class {
	#name : #MocoSqlOracleCreateTable,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Moco-SqlOracle-Model'
}

{ #category : #accessing }
MocoSqlOracleCreateTable >> name [
	^ name
]

{ #category : #accessing }
MocoSqlOracleCreateTable >> name: aString [
	name := aString
]

{ #category : #printing }
MocoSqlOracleCreateTable >> printTo: aStream [
	aStream
		nextPutAll: '|--SQL-----------';
		cr;
		nextPutAll: '| ' , (self toSql copyReplaceAll: (Character cr asString) with: (Character cr asString , '| '));
		cr;
		nextPutAll: '|----------------'.
]

{ #category : #'as yet unclassified' }
MocoSqlOracleCreateTable >> toSql [
	^ 'CREATE TABLE ' , (MocoSqlOracleEscaping escapeTableName: (self name)) , ';'
]
