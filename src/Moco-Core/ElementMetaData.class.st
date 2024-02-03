"
Stores meta data about a WrappedElement.
"
Class {
	#name : #ElementMetaData,
	#superclass : #Object,
	#instVars : [
		'outElements',
		'exhausted'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
ElementMetaData >> exhausted [
	^ exhausted
]

{ #category : #accessing }
ElementMetaData >> exhausted: aBoolean [
	exhausted := aBoolean
]

{ #category : #initialization }
ElementMetaData >> initialize [
	super initialize.
	
	exhausted := false.
	outElements := OrderedCollection new.
]

{ #category : #accessing }
ElementMetaData >> outElements [
	^ outElements
]
