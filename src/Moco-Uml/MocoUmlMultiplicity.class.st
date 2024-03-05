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

{ #category : #'instance creation' }
MocoUmlMultiplicity class >> lower: aLowerNumber upper: anUpperNumber [
	| inst |
	inst := self new.
	
	inst lower: aLowerNumber;
		upper: anUpperNumber.
		
	^ inst
]

{ #category : #'instance creation' }
MocoUmlMultiplicity class >> value: aNumber [
	| inst |
	inst := self new.
	
	inst lower: aNumber;
		upper: aNumber.
	
	^ inst
]

{ #category : #initialization }
MocoUmlMultiplicity >> initialize [
	super initialize.

	lower := MocoUmlMultiplicityBound value: 0.
	upper := MocoUmlMultiplicityBound unbounded.
]

{ #category : #accessing }
MocoUmlMultiplicity >> lower [
	^ lower
]

{ #category : #accessing }
MocoUmlMultiplicity >> lower: aBound [
	aBound ifNil: [
		lower := MocoUmlMultiplicityBound value: 0.
	] ifNotNil: [
		(aBound isKindOf: Number)
			ifTrue: [ lower := MocoUmlMultiplicityBound value: aBound ]
			ifFalse: [ lower := aBound ]
	]
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
	aBound ifNil: [
		upper := MocoUmlMultiplicityBound unbounded.
	] ifNotNil: [
		(aBound isKindOf: Number)
			ifTrue: [ upper := MocoUmlMultiplicityBound value: aBound ]
			ifFalse: [ upper := aBound ]
	]
]
