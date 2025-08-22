"
Represents a CREATE TABLE statement in a Microsoft SQL Server database.
"
Class {
	#name : 'MocoSqlMssqlCreateTable',
	#superclass : 'Object',
	#instVars : [
		'name',
		'columnDefinitions',
		'constraintDefinitions'
	],
	#category : 'Moco-SqlMssql-Model',
	#package : 'Moco-SqlMssql',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlMssqlCreateTable >> columnDefinitions [
	^ columnDefinitions
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTable >> constraintDefinitions [
	^ constraintDefinitions
]

{ #category : 'initialization' }
MocoSqlMssqlCreateTable >> initialize [
	super initialize.
	
	name := ''.
	columnDefinitions := OrderedCollection new.
	constraintDefinitions := OrderedCollection new
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTable >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlMssqlCreateTable >> name: aString [
	name := aString
]

{ #category : 'private - printing' }
MocoSqlMssqlCreateTable >> printColumnDefinitionsTo: aStream [
	columnDefinitions ifEmpty: [ ^ self ].
	
	aStream nextPutAll: ' ('.
	
	columnDefinitions do: [ :each |
		aStream
			cr;
			nextPutAll: '  ';
			nextPutAll: each.
		
		(each == (columnDefinitions last)) ifFalse: [ aStream nextPutAll: ',' ]
	].
	
	aStream nextPutAll: ')'
]

{ #category : 'private - printing' }
MocoSqlMssqlCreateTable >> printConstraintDefinitionsTo: aStream [
	constraintDefinitions do: [ :each |
		aStream
			cr;
			cr;
			nextPutAll: 'ALTER TABLE ';
			nextPutAll: (MocoSqlMssqlEscaping escapeName: name);
			nextPutAll: ' ADD CONSTRAINT ';
			nextPutAll: each;
			nextPutAll: ';'
	]
]

{ #category : 'printing' }
MocoSqlMssqlCreateTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'CREATE TABLE ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: name).
	
	self printColumnDefinitionsTo: aStream.

	aStream nextPutAll: ';'.
	
	self printConstraintDefinitionsTo: aStream
]

{ #category : 'printing' }
MocoSqlMssqlCreateTable >> printTo: aStream [
	self printSqlTo: aStream
]
