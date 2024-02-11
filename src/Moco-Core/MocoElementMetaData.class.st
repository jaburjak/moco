"
Stores meta data about a WrappedElement.
"
Class {
	#name : #MocoElementMetaData,
	#superclass : #Object,
	#instVars : [
		'outElements',
		'exhausted'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
MocoElementMetaData >> exhausted [
	^ exhausted
]

{ #category : #accessing }
MocoElementMetaData >> exhausted: aBoolean [
	exhausted := aBoolean
]

{ #category : #initialization }
MocoElementMetaData >> initialize [
	super initialize.
	
	exhausted := false.
	outElements := OrderedCollection new.
]

{ #category : #accessing }
MocoElementMetaData >> outElements [
	^ outElements
]
