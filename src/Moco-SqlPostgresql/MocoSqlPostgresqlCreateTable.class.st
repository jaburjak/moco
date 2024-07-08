"
Represents a CREATE TABLE statement in a PostgreSQL database.
"
Class {
	#name : #MocoSqlPostgresqlCreateTable,
	#superclass : #Object,
	#instVars : [
		'name',
		'columnDefinitions',
		'constraintDefinitions'
	],
	#category : #'Moco-SqlPostgresql-Model'
}

{ #category : #accessing }
MocoSqlPostgresqlCreateTable >> columnDefinitions [
	^ columnDefinitions
]

{ #category : #accessing }
MocoSqlPostgresqlCreateTable >> constraintDefinitions [
	^ constraintDefinitions
]

{ #category : #initialization }
MocoSqlPostgresqlCreateTable >> initialize [
	super initialize.
	
	name := ''.
	columnDefinitions := OrderedCollection new.
	constraintDefinitions := OrderedCollection new
]

{ #category : #accessing }
MocoSqlPostgresqlCreateTable >> name [
	^ name
]

{ #category : #accessing }
MocoSqlPostgresqlCreateTable >> name: aString [
	name := aString
]

{ #category : #'private - printing' }
MocoSqlPostgresqlCreateTable >> printColumnDefinitionsTo: aStream [
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
MocoSqlPostgresqlCreateTable >> printConstraintDefinitionsTo: aStream [
	constraintDefinitions do: [ :each |
		aStream
			cr;
			cr;
			nextPutAll: 'ALTER TABLE ';
			nextPutAll: (MocoSqlPostgresqlEscaping escapeName: name);
			nextPutAll: ' ADD CONSTRAINT ';
			nextPutAll: each;
			nextPutAll: ';'
	]
]

{ #category : #printing }
MocoSqlPostgresqlCreateTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'CREATE TABLE ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: name).
	
	self printColumnDefinitionsTo: aStream.

	aStream nextPutAll: ';'.
	
	self printConstraintDefinitionsTo: aStream
]

{ #category : #printing }
MocoSqlPostgresqlCreateTable >> printTo: aStream [
	self printSqlTo: aStream
]
