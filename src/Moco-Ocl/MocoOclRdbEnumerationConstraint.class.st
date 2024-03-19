"
Represents an OCL invariant for enumerated columns after transformation to a relational database model.
"
Class {
	#name : #MocoOclRdbEnumerationConstraint,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'column',
		'values'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclRdbEnumerationConstraint >> column [
	^ column
]

{ #category : #accessing }
MocoOclRdbEnumerationConstraint >> column: aMocoRdbColumn [
	column := aMocoRdbColumn
]

{ #category : #initialization }
MocoOclRdbEnumerationConstraint >> initialize [
	super initialize.
	
	values := OrderedCollection new
]

{ #category : #printing }
MocoOclRdbEnumerationConstraint >> printOclTo: aStream [
	super printOclTo: aStream.
	
	aStream
		nextPutAll: (' OR ' join: (values collect: [ :each | 'self.' , (column name) , ' = ''' , each , '''' ]))
]

{ #category : #accessing }
MocoOclRdbEnumerationConstraint >> values [
	^ values
]
