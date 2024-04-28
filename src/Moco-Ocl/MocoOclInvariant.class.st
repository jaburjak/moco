"
Base class for OCL invariants.
"
Class {
	#name : #MocoOclInvariant,
	#superclass : #MocoOclConstraint,
	#category : #'Moco-Ocl-Model'
}

{ #category : #'instance creation' }
MocoOclInvariant class >> new [
	(self asString = 'MocoOclInvariant') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #initialization }
MocoOclInvariant >> initialize [
	super initialize.
	
	name := ''
]

{ #category : #printing }
MocoOclInvariant >> printOclTo: aStream [
	aStream
		nextPutAll: 'context ' , context name , ' inv ' , name , ':';
		cr
]
