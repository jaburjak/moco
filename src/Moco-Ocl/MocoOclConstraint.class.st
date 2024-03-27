"
Base class for OCL constraints.
"
Class {
	#name : #MocoOclConstraint,
	#superclass : #Object,
	#instVars : [
		'context'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #'instance creation' }
MocoOclConstraint class >> new [
	(self asString = 'MocoOclConstraint') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #accessing }
MocoOclConstraint >> context [
	^ context
]

{ #category : #accessing }
MocoOclConstraint >> context: anObject [
	context := anObject
]
