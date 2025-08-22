"
Represents a PRIMARY KEY constraint in a relational database.
"
Class {
	#name : 'MocoRdbPrimaryKey',
	#superclass : 'MocoRdbConstraint',
	#instVars : [
		'columns'
	],
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoRdbPrimaryKey >> columns [
	^ columns
]

{ #category : 'initialization' }
MocoRdbPrimaryKey >> initialize [
	super initialize.
	
	columns := OrderedCollection new
]

{ #category : 'printing' }
MocoRdbPrimaryKey >> printTo: aStream [
	aStream nextPutAll: '<<PK>> '.

	super printTo: aStream.
	
	aStream
		nextPutAll: '(';
		nextPutAll: (',' join: (columns collect: [ :each | each name ]));
		nextPutAll: ')'
]
