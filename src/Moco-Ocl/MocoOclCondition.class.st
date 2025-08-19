"
Base class that represents an OCL pre or post codition.
"
Class {
	#name : 'MocoOclCondition',
	#superclass : 'MocoOclConstraint',
	#instVars : [
		'operation'
	],
	#category : 'Moco-Ocl-Model',
	#package : 'Moco-Ocl',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MocoOclCondition class >> new [
	(self asString = 'MocoOclPostCondition') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : 'accessing' }
MocoOclCondition class >> type [
	^ self subclassResponsibility
]

{ #category : 'initialization' }
MocoOclCondition >> initialize [
	super initialize.
	
	name := ''
]

{ #category : 'accessing' }
MocoOclCondition >> operation [
	^ operation
]

{ #category : 'accessing' }
MocoOclCondition >> operation: aByteSymbol [
	operation := aByteSymbol
]

{ #category : 'printing' }
MocoOclCondition >> printOclTo: aStream [
	aStream
		nextPutAll: 'context ';
		nextPutAll: context name;
		nextPutAll: '::';
		nextPutAll: (operation asString asUppercase);
		nextPutAll: '() ';
		nextPutAll: (self class type);
		nextPutAll: ' ';
		nextPutAll: name;
		nextPutAll: ':';
		cr
]
