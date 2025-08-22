"
Represents a CREATE PROCEDURE statement in a Microsoft SQL Server database.
"
Class {
	#name : 'MocoSqlMssqlCreateProcedure',
	#superclass : 'Object',
	#instVars : [
		'name',
		'inputs',
		'body',
		'comment'
	],
	#category : 'Moco-SqlMssql-Model',
	#package : 'Moco-SqlMssql',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedure >> body [
	^ body
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedure >> body: aString [
	body := aString
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedure >> comment [
	^ comment
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedure >> comment: aString [
	comment := aString
]

{ #category : 'initialization' }
MocoSqlMssqlCreateProcedure >> initialize [
	super initialize.
	
	name := ''.
	inputs := OrderedCollection new.
	body := ''.
	comment := ''
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedure >> inputs [
	^ inputs
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedure >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlMssqlCreateProcedure >> name: aString [
	name := aString
]

{ #category : 'private - printing' }
MocoSqlMssqlCreateProcedure >> printArgumentsTo: aStream [
	| args |

	aStream nextPutAll: '('.
	
	args := inputs collect: [ :i |
		| stream |
		stream := String new writeStream.
		i printSqlTo: stream.
		stream contents
	].

	aStream
		nextPutAll: (', ' join: args);
		nextPutAll: ')'
]

{ #category : 'printing' }
MocoSqlMssqlCreateProcedure >> printSqlTo: aStream [
	comment ifNotEmpty: [
		aStream nextPutAll: '-- '; nextPutAll: comment; cr.
	].

	aStream
		nextPutAll: 'CREATE PROCEDURE ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: name).
	
	self printArgumentsTo: aStream.
	
	aStream cr;
		nextPutAll: 'AS BEGIN';
		cr;
		nextPutAll: body;
		cr;
		nextPutAll: 'END;'
]

{ #category : 'printing' }
MocoSqlMssqlCreateProcedure >> printTo: aStream [
	self printSqlTo: aStream
]
