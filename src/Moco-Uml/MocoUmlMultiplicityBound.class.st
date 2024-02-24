Class {
	#name : #MocoUmlMultiplicityBound,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #'instance creation' }
MocoUmlMultiplicityBound class >> new [
	self error: 'Use either unbounded or value: message to create a new instance.'
]

{ #category : #'as yet unclassified' }
MocoUmlMultiplicityBound class >> unbounded [
	| inst |
	inst := self basicNew.
	
	^ inst
]

{ #category : #accessing }
MocoUmlMultiplicityBound class >> value: aNumber [
	| inst |
	inst := self basicNew.
	
	aNumber = '*' ifFalse: [
		inst value: aNumber
	].
	
	^ inst
]

{ #category : #converting }
MocoUmlMultiplicityBound >> asString [
	self isUnbounded ifTrue: [ ^ '*' ] ifFalse: [ ^ value asString ].
]

{ #category : #testing }
MocoUmlMultiplicityBound >> isUnbounded [
	^ value isNil
]

{ #category : #testing }
MocoUmlMultiplicityBound >> printOn: aStream [
	super printOn: aStream.
	aStream nextPutAll: ' withValue: '.
	self isUnbounded ifTrue: [ aStream nextPutAll: '*' ] ifFalse: [ aStream nextPutAll: value ].
]

{ #category : #testing }
MocoUmlMultiplicityBound >> value [
	^ value
]

{ #category : #accessing }
MocoUmlMultiplicityBound >> value: aNumber [
	value := aNumber
]
