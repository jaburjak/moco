"
Represents a CREATE TABLE statement in a MySQL database.
"
Class {
	#name : #MocoSqlMysqlCreateTable,
	#superclass : #Object,
	#instVars : [
		'name',
		'columnDefinitions',
		'constraintDefinitions'
	],
	#category : #'Moco-SqlMysql-Model'
}

{ #category : #accessing }
MocoSqlMysqlCreateTable >> columnDefinitions [
	^ columnDefinitions
]

{ #category : #accessing }
MocoSqlMysqlCreateTable >> constraintDefinitions [
	^ constraintDefinitions
]

{ #category : #initialization }
MocoSqlMysqlCreateTable >> initialize [
	super initialize.
	
	name := ''.
	columnDefinitions := OrderedCollection new.
	constraintDefinitions := OrderedCollection new
]

{ #category : #accessing }
MocoSqlMysqlCreateTable >> name [
	^ name
]

{ #category : #accessing }
MocoSqlMysqlCreateTable >> name: aString [
	name := aString
]

{ #category : #'private - printing' }
MocoSqlMysqlCreateTable >> printColumnDefinitionsTo: aStream [
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

{ #category : #'private - printing' }
MocoSqlMysqlCreateTable >> printConstraintDefinitionsTo: aStream [
	constraintDefinitions do: [ :each |
		aStream
			cr;
			cr;
			nextPutAll: 'ALTER TABLE ';
			nextPutAll: (MocoSqlMysqlEscaping escapeName: name);
			nextPutAll: ' ADD CONSTRAINT ';
			nextPutAll: each;
			nextPutAll: ';'
	]
]

{ #category : #printing }
MocoSqlMysqlCreateTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'CREATE TABLE ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: name).
	
	self printColumnDefinitionsTo: aStream.

	aStream nextPutAll: ';'.
	
	self printConstraintDefinitionsTo: aStream
]

{ #category : #printing }
MocoSqlMysqlCreateTable >> printTo: aStream [
	self printSqlTo: aStream
]
