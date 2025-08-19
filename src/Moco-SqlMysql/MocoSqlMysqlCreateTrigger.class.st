"
Represents a CREATE TRIGGER statement in a MySQL database.
"
Class {
	#name : 'MocoSqlMysqlCreateTrigger',
	#superclass : 'Object',
	#instVars : [
		'name',
		'time',
		'event',
		'table',
		'body'
	],
	#category : 'Moco-SqlMysql-Model',
	#package : 'Moco-SqlMysql',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> body [
	^ body
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> body: aString [
	body := aString
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> event [
	^ event
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> event: aSymbol [
	event := aSymbol
]

{ #category : 'initialization' }
MocoSqlMysqlCreateTrigger >> initialize [
	super initialize.
	
	name := ''.
	time := ''.
	event := ''.
	table := ''.
	body := ''
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> name: aString [
	name := aString
]

{ #category : 'printing' }
MocoSqlMysqlCreateTrigger >> printSqlTo: aStream [
	aStream
		nextPutAll: 'CREATE TRIGGER ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: name);
		cr;
		nextPutAll: time;
		nextPutAll: ' ';
		nextPutAll: event;
		nextPutAll: ' ON ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: table);
		cr;
		nextPutAll: 'FOR EACH ROW';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: body.
	
	((body isNotEmpty) and: [ (body trimRight last asString) ~= ';' ]) ifTrue: [ aStream nextPutAll: ';' ].

	aStream cr; nextPutAll: 'END;'
]

{ #category : 'printing' }
MocoSqlMysqlCreateTrigger >> printTo: aStream [
	self printSqlTo: aStream
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> table [
	^ table
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> table: aString [
	table := aString
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> time [
	^ time
]

{ #category : 'accessing' }
MocoSqlMysqlCreateTrigger >> time: aSymbol [
	time := aSymbol
]
