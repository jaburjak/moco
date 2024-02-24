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

{ #category : #initialization }
MocoUmlMultiplicity >> initialize [
	lower := MocoUmlMultiplicityBound value: 0.
	upper := MocoUmlMultiplicityBound unbounded.
]

{ #category : #accessing }
MocoUmlMultiplicity >> lower [
	^ lower
]

{ #category : #accessing }
MocoUmlMultiplicity >> lower: aBound [
	lower := aBound
]

{ #category : #printing }
MocoUmlMultiplicity >> printTo: aStream [
	(((lower isUnbounded) or: (lower value = 0)) and: (upper isUnbounded)) ifTrue: [ aStream nextPutAll: '[*]' ] ifFalse: [ aStream nextPutAll: '[' , (lower asString), '..' , (upper asString) , ']' ]
]

{ #category : #accessing }
MocoUmlMultiplicity >> upper [
	^ upper
]

{ #category : #accessing }
MocoUmlMultiplicity >> upper: aBound [
	upper := aBound
]
