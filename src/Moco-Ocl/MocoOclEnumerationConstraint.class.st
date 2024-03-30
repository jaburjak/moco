"
Represents an OCL constraint that restrict attribute values to a predefined set of values.
"
Class {
	#name : #MocoOclEnumerationConstraint,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'attribute',
		'values'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclEnumerationConstraint >> attribute [
	^ attribute
]

{ #category : #accessing }
MocoOclEnumerationConstraint >> attribute: aMocoUmlAttribute [
	attribute := aMocoUmlAttribute
]

{ #category : #initialization }
MocoOclEnumerationConstraint >> initialize [
	super initialize.
	
	values := OrderedCollection new
]

{ #category : #printing }
MocoOclEnumerationConstraint >> printOclTo: aStream [
	super printOclTo: aStream.
	
	(attribute multiplicity lower isZero) ifTrue: [
		aStream
			nextPutAll: 'self.';
			nextPutAll: (attribute name);
			nextPutAll: ' = OclVoid'.
		
		(values ifNotEmpty: [ aStream nextPutAll: ' OR ' ])
	].
	
	aStream
		nextPutAll: (' OR ' join: (values collect: [ :each | 'self.' , (attribute name) , ' = ''' , each , '''' ]))
]

{ #category : #accessing }
MocoOclEnumerationConstraint >> values [
	^ values
]
