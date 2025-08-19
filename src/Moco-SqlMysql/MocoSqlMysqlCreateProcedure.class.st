"
Represents a CREATE PROCEDURE statement in a MySQL database.
"
Class {
	#name : 'MocoSqlMysqlCreateProcedure',
	#superclass : 'Object',
	#instVars : [
		'name',
		'inputs',
		'body',
		'comment'
	],
	#category : 'Moco-SqlMysql-Model',
	#package : 'Moco-SqlMysql',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlMysqlCreateProcedure >> body [
	^ body
]

{ #category : 'accessing' }
MocoSqlMysqlCreateProcedure >> body: aString [
	body := aString
]

{ #category : 'accessing' }
MocoSqlMysqlCreateProcedure >> comment [
	^ comment
]

{ #category : 'accessing' }
MocoSqlMysqlCreateProcedure >> comment: aString [
	comment := aString
]

{ #category : 'initialization' }
MocoSqlMysqlCreateProcedure >> initialize [
	super initialize.
	
	name := ''.
	inputs := OrderedCollection new.
	body := ''.
	comment := ''
]

{ #category : 'accessing' }
MocoSqlMysqlCreateProcedure >> inputs [
	^ inputs
]

{ #category : 'accessing' }
MocoSqlMysqlCreateProcedure >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlMysqlCreateProcedure >> name: aString [
	name := aString
]

{ #category : 'private - printing' }
MocoSqlMysqlCreateProcedure >> printArgumentsTo: aStream [
	| args |

	aStream nextPutAll: '('.
	
	args := inputs collect: [ :i |
		| stream |
		stream := String new writeStream.
		stream nextPutAll: 'IN '.
		i printSqlTo: stream.
		stream contents
	].

	aStream
		nextPutAll: (', ' join: args);
		nextPutAll: ')'
]

{ #category : 'printing' }
MocoSqlMysqlCreateProcedure >> printSqlTo: aStream [
	comment ifNotEmpty: [
		aStream nextPutAll: '-- '; nextPutAll: comment; cr.
	].

	aStream
		nextPutAll: 'CREATE PROCEDURE ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: name).
	
	self printArgumentsTo: aStream.
	
	aStream cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: body;
		cr;
		nextPutAll: 'END;'
]

{ #category : 'printing' }
MocoSqlMysqlCreateProcedure >> printTo: aStream [
	self printSqlTo: aStream
]
