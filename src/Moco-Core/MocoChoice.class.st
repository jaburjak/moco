"
Represents an single option when transformation process can go multiple paths.
"
Class {
	#name : #MocoChoice,
	#superclass : #Object,
	#instVars : [
		'label',
		'id'
	],
	#category : #'Moco-Core-Engine'
}

{ #category : #accessing }
MocoChoice >> id [
	^ id
]

{ #category : #accessing }
MocoChoice >> id: anObject [
	id := anObject
]

{ #category : #initialization }
MocoChoice >> initialize [
	label := ''
]

{ #category : #accessing }
MocoChoice >> label [
	^ label
]

{ #category : #accessing }
MocoChoice >> label: aString [
	label := aString
]
