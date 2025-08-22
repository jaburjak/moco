"
Represents a UNIQUE KEY constraint in a relational database.
"
Class {
	#name : 'MocoRdbUniqueKey',
	#superclass : 'MocoRdbConstraint',
	#instVars : [
		'columns'
	],
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoRdbUniqueKey >> columns [
	^ columns
]

{ #category : 'initialization' }
MocoRdbUniqueKey >> initialize [
	super initialize.
	
	columns := OrderedCollection new
]

{ #category : 'printing' }
MocoRdbUniqueKey >> printTo: aStream [
	aStream nextPutAll: '<<unique>> '.

	super printTo: aStream.
	
	aStream
		nextPutAll: '(';
		nextPutAll: (',' join: (columns collect: [ :each | each name ]));
		nextPutAll: ')'
]
