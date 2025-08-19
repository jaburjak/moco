"
An OCL condition representing an immutable column in a relational database model.
"
Class {
	#name : 'MocoOclRdbImmutableColumnCondition',
	#superclass : 'MocoOclPostCondition',
	#instVars : [
		'column'
	],
	#category : 'Moco-Ocl-Model',
	#package : 'Moco-Ocl',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoOclRdbImmutableColumnCondition >> column [
	^ column
]

{ #category : 'accessing' }
MocoOclRdbImmutableColumnCondition >> column: aMocoRdbColumn [
	column := aMocoRdbColumn
]

{ #category : 'printing' }
MocoOclRdbImmutableColumnCondition >> printOclTo: aStream [
	super printOclTo: aStream.

	aStream
		nextPutAll: 'self.';
		nextPutAll: (column name);
		nextPutAll: ' = self.';
		nextPutAll: (column name);
		nextPutAll: '@pre'
]
