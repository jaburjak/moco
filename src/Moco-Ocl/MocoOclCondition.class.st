"
Base class that represents an OCL pre or post codition.
"
Class {
	#name : #MocoOclCondition,
	#superclass : #Object,
	#instVars : [
		'name',
		'context',
		'operation'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #'instance creation' }
MocoOclCondition class >> new [
	(self asString = 'MocoOclPostCondition') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #accessing }
MocoOclCondition class >> type [
	^ self subclassResponsibility
]

{ #category : #accessing }
MocoOclCondition >> context [
	^ context
]

{ #category : #accessing }
MocoOclCondition >> context: anObject [
	context := anObject
]

{ #category : #initialization }
MocoOclCondition >> initialize [
	super initialize.
	
	name := ''
]

{ #category : #accessing }
MocoOclCondition >> name [
	^ name
]

{ #category : #accessing }
MocoOclCondition >> name: aString [
	name := aString
]

{ #category : #accessing }
MocoOclCondition >> operation [
	^ operation
]

{ #category : #accessing }
MocoOclCondition >> operation: aByteSymbol [
	operation := aByteSymbol
]

{ #category : #printing }
MocoOclCondition >> printTo: aStream [
	aStream
		nextPutAll: '+--OCL-----------';
		cr;
		nextPutAll: '| context ';
		nextPutAll: context name;
		nextPutAll: '::';
		nextPutAll: (operation asString asUppercase);
		nextPutAll: ' ';
		nextPutAll: (self class type);
		nextPutAll: ' ';
		nextPutAll: name;
		nextPutAll: ':';
		cr
]
