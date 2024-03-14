"
Base class for OCL invariants.
"
Class {
	#name : #MocoOclInvariant,
	#superclass : #Object,
	#instVars : [
		'context',
		'name'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #'instance creation' }
MocoOclInvariant class >> new [
	(self asString = 'MocoOclInvariant') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #accessing }
MocoOclInvariant >> context [
	^ context
]

{ #category : #accessing }
MocoOclInvariant >> context: anObject [
	context := anObject
]

{ #category : #initialization }
MocoOclInvariant >> initialize [
	super initialize.
	
	name := ''
]

{ #category : #accessing }
MocoOclInvariant >> name [
	^ name
]

{ #category : #accessing }
MocoOclInvariant >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOclInvariant >> printTo: aStream [
	aStream
		nextPutAll: '|--OCL-----------';
		cr;
		nextPutAll: '| context ' , context name , ' inv ' , name , ':';
		cr
]
