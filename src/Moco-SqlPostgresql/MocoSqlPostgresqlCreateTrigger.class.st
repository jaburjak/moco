"
Represents a CREATE TRIGGER statement in a PostgreSQL database.
"
Class {
	#name : 'MocoSqlPostgresqlCreateTrigger',
	#superclass : 'Object',
	#instVars : [
		'name',
		'time',
		'event',
		'table',
		'granularity',
		'body'
	],
	#category : 'Moco-SqlPostgresql-Model',
	#package : 'Moco-SqlPostgresql',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> body [
	^ body
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> body: aString [
	body := aString
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> event [
	^ event
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> event: aSymbol [
	event := aSymbol
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> granularity [
	^ granularity
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> granularity: aSymbol [
	granularity := aSymbol
]

{ #category : 'initialization' }
MocoSqlPostgresqlCreateTrigger >> initialize [
	super initialize.
	
	name := ''.
	time := ''.
	event := ''.
	table := ''.
	granularity := #'EACH STATEMENT'.
	body := ''
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> name: aString [
	name := aString
]

{ #category : 'printing' }
MocoSqlPostgresqlCreateTrigger >> printSqlTo: aStream [
	| fnName |
	fnName := 'trg_' , (name asLowercase).

	aStream
		nextPutAll: 'CREATE FUNCTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: fnName);
		nextPutAll: '()';
		cr;
		nextPutAll: 'RETURNS TRIGGER AS $$';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  ' , (body copyReplaceAll: (String cr) with: (String cr , '  ')).

	((body isNotEmpty) and: [ (body trimRight last asString) ~= ';' ]) ifTrue: [ aStream nextPutAll: ';' ].

	aStream
		cr;
		nextPutAll: 'END;';
		cr;
		nextPutAll: '$$ LANGUAGE plpgsql;';
		cr; cr.

	aStream
		nextPutAll: 'CREATE TRIGGER ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: name);
		cr;
		nextPutAll: time;
		nextPutAll: ' ';
		nextPutAll: event;
		nextPutAll: ' ON ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: table);
		cr.
	
	granularity ifNotEmpty: [
		aStream
			nextPutAll: 'FOR ';
			nextPutAll: granularity;
			cr
	].
	
	aStream
		nextPutAll: 'EXECUTE FUNCTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: fnName);
		nextPutAll: '();'
]

{ #category : 'printing' }
MocoSqlPostgresqlCreateTrigger >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> table [
	^ table
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> table: aString [
	table := aString
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> time [
	^ time
]

{ #category : 'accessing' }
MocoSqlPostgresqlCreateTrigger >> time: aSymbol [
	time := aSymbol
]
