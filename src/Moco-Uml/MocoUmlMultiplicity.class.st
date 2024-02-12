"
Stores the multiplicity of an attribute.

Value of nil indicates no restriction.
"
Class {
	#name : #MocoUmlMultiplicity,
	#superclass : #Object,
	#instVars : [
		'lower',
		'upper'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlMultiplicity >> lower [
	^ lower
]

{ #category : #accessing }
MocoUmlMultiplicity >> lower: aNumber [
	lower := (aNumber = '*') ifTrue: [ nil ] ifFalse: [ aNumber ]
]

{ #category : #printing }
MocoUmlMultiplicity >> printTo: aStream [
	((lower = nil or: lower = 0) and: (upper = nil)) ifTrue: [ aStream nextPutAll: '[*]' ] ifFalse: [ aStream nextPutAll: '[' , (lower ifNil: [ '*' ] ifNotNil: [ lower asString ]), '..' , (upper ifNil: [ '*' ] ifNotNil: [ upper asString ]) , ']' ]
]

{ #category : #accessing }
MocoUmlMultiplicity >> upper [
	^ upper
]

{ #category : #accessing }
MocoUmlMultiplicity >> upper: aNumber [
	upper := (aNumber = '*') ifTrue: [ nil ] ifFalse: [ aNumber ]
]
