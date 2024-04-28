"
Base class for OCL constraints.
"
Class {
	#name : #MocoOclConstraint,
	#superclass : #Object,
	#instVars : [
		'name',
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

{ #category : #accessing }
MocoOclConstraint >> name [
	^ name
]

{ #category : #accessing }
MocoOclConstraint >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOclConstraint >> printOclTo: aStream [
	"Prints the OCL code to the given stream."
	
	^ self subclassResponsibility
]

{ #category : #printing }
MocoOclConstraint >> printTo: aStream [
	| ocl |
	ocl := String new writeStream.
	self printOclTo: ocl.
	
	ocl := (ocl contents) copyReplaceAll: (Character cr asString) with: ((Character cr asString) , '| ').
	
	aStream
		nextPutAll: '+--OCL-----------';
		cr;
		nextPutAll: '| ';
		nextPutAll: ocl;
		cr;
		nextPutAll: '+----------------'
]
