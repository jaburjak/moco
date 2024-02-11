"
Represents a table in an Oracle Database.
"
Class {
	#name : #MocoRdbOracleTable,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Moco-RdbOracle-Model'
}

{ #category : #accessing }
MocoRdbOracleTable >> name [
	^ name
]

{ #category : #accessing }
MocoRdbOracleTable >> name: aString [
	name := aString
]

{ #category : #printing }
MocoRdbOracleTable >> printTo: aStream [
	aStream
		nextPutAll: '|--RDB-----------';
		cr;
		nextPutAll: '| <<Table>>';
		cr;
		nextPutAll: '| ' , name;
		cr;
		nextPutAll: '|----------------'.
]
