"
Base class for OCL invariants.
"
Class {
	#name : #MocoOclInvariant,
	#superclass : #MocoOclConstraint,
	#instVars : [
		'name'
	],
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

{ #category : #accessing }
MocoOclInvariant >> name [
	^ name
]

{ #category : #accessing }
MocoOclInvariant >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOclInvariant >> printOclTo: aStream [
	aStream
		nextPutAll: 'context ' , context name , ' inv ' , name , ':';
		cr
]

{ #category : #printing }
MocoOclInvariant >> printTo: aStream [
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
