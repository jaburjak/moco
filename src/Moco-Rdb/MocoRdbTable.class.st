"
Represents a table in an Oracle Database.
"
Class {
	#name : #MocoRdbTable,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Moco-Rdb-Model'
}

{ #category : #accessing }
MocoRdbTable >> name [
	^ name
]

{ #category : #accessing }
MocoRdbTable >> name: aString [
	name := aString
]

{ #category : #printing }
MocoRdbTable >> printTo: aStream [
	aStream
		nextPutAll: '|--RDB-----------';
		cr;
		nextPutAll: '| <<Table>>';
		cr;
		nextPutAll: '| ' , name;
		cr;
		nextPutAll: '|----------------'.
]
