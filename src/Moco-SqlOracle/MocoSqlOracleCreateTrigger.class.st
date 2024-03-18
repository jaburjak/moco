"
Represents a CREATE TRIGGER statement in an Oracle database.
"
Class {
	#name : #MocoSqlOracleCreateTrigger,
	#superclass : #Object,
	#instVars : [
		'name',
		'time',
		'event',
		'table',
		'granularity',
		'body'
	],
	#category : #'Moco-SqlOracle-Model'
}

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> body [
	^ body
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> body: aString [
	body := aString
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> event [
	^ event
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> event: aSymbol [
	event := aSymbol
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> granularity [
	^ granularity
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> granularity: aSymbol [
	granularity := aSymbol
]

{ #category : #initialization }
MocoSqlOracleCreateTrigger >> initialize [
	super initialize.
	
	name := ''.
	time := ''.
	event := ''.
	table := ''.
	granularity := ''.
	body := ''
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> name [
	^ name
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> name: aString [
	name := aString
]

{ #category : #printing }
MocoSqlOracleCreateTrigger >> printSqlTo: aStream [
	aStream
		nextPutAll: 'CREATE TRIGGER ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: name);
		cr;
		nextPutAll: time;
		nextPutAll: ' ';
		nextPutAll: event;
		nextPutAll: ' ON ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: table);
		cr.
	
	granularity ifNotEmpty: [
		aStream
			nextPutAll: 'FOR ';
			nextPutAll: granularity;
			cr
	].
	
	aStream nextPutAll: body.
	
	((body isNotEmpty) and: [ (body trimRight last asString) ~= ';' ]) ifTrue: [ aStream nextPutAll: ';' ]
]

{ #category : #printing }
MocoSqlOracleCreateTrigger >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> table [
	^ table
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> table: aString [
	table := aString
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> time [
	^ time
]

{ #category : #accessing }
MocoSqlOracleCreateTrigger >> time: aSymbol [
	time := aSymbol
]
