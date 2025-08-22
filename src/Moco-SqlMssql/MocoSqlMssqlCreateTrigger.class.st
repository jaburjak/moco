"
Represents a CREATE TRIGGER statement in a Microsoft SQL Server database.
"
Class {
	#name : 'MocoSqlMssqlCreateTrigger',
	#superclass : 'Object',
	#instVars : [
		'name',
		'time',
		'event',
		'table',
		'body'
	],
	#category : 'Moco-SqlMssql-Model',
	#package : 'Moco-SqlMssql',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> body [
	^ body
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> body: aString [
	body := aString
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> event [
	^ event
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> event: aSymbol [
	event := aSymbol
]

{ #category : 'initialization' }
MocoSqlMssqlCreateTrigger >> initialize [
	super initialize.
	
	name := ''.
	event := ''.
	table := ''.
	body := ''
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> name: aString [
	name := aString
]

{ #category : 'printing' }
MocoSqlMssqlCreateTrigger >> printSqlTo: aStream [
	aStream
		nextPutAll: 'CREATE TRIGGER ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: name);
		cr;
		nextPutAll: 'ON ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: table);
		nextPutAll: ' AFTER ';
		nextPutAll: event;
		nextPutAll: ' AS BEGIN';
		cr;
		nextPutAll: body.
	
	((body isNotEmpty) and: [ (body trimRight last asString) ~= ';' ]) ifTrue: [ aStream nextPutAll: ';' ].

	aStream cr; nextPutAll: 'END;'
]

{ #category : 'printing' }
MocoSqlMssqlCreateTrigger >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> table [
	^ table
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTrigger >> table: aString [
	table := aString
]
