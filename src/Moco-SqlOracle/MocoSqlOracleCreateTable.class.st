"
Represents a CREATE TABLE statement in an Oracle database.
"
Class {
	#name : 'MocoSqlOracleCreateTable',
	#superclass : 'Object',
	#instVars : [
		'name',
		'columnDefinitions',
		'constraintDefinitions'
	],
	#category : 'Moco-SqlOracle-Model',
	#package : 'Moco-SqlOracle',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoSqlOracleCreateTable >> columnDefinitions [
	^ columnDefinitions
]

{ #category : 'accessing' }
MocoSqlOracleCreateTable >> constraintDefinitions [
	^ constraintDefinitions
]

{ #category : 'initialization' }
MocoSqlOracleCreateTable >> initialize [
	super initialize.
	
	name := ''.
	columnDefinitions := OrderedCollection new.
	constraintDefinitions := OrderedCollection new
]

{ #category : 'accessing' }
MocoSqlOracleCreateTable >> name [
	^ name
]

{ #category : 'accessing' }
MocoSqlOracleCreateTable >> name: aString [
	name := aString
]

{ #category : 'private - printing' }
MocoSqlOracleCreateTable >> printColumnDefinitionsTo: aStream [
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
MocoSqlOracleCreateTable >> printConstraintDefinitionsTo: aStream [
	constraintDefinitions do: [ :each |
		aStream
			cr;
			cr;
			nextPutAll: 'ALTER TABLE ';
			nextPutAll: (MocoSqlOracleEscaping escapeName: name);
			nextPutAll: ' ADD CONSTRAINT ';
			nextPutAll: each;
			nextPutAll: ';'
	]
]

{ #category : 'printing' }
MocoSqlOracleCreateTable >> printSqlTo: aStream [
	aStream
		nextPutAll: 'CREATE TABLE ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: name).
	
	self printColumnDefinitionsTo: aStream.

	aStream nextPutAll: ';'.
	
	self printConstraintDefinitionsTo: aStream
]

{ #category : 'printing' }
MocoSqlOracleCreateTable >> printTo: aStream [
	self printSqlTo: aStream
]
