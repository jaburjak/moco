"
Container for WrappedElement instances.
"
Class {
	#name : #WrappedModel,
	#superclass : #Object,
	#instVars : [
		'elements',
		'meta'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
WrappedModel >> elements [
	^ elements
]

{ #category : #initialization }
WrappedModel >> initialize [
	super initialize.
	
	elements := OrderedCollection new.
	meta := ModelMetaData new.
]

{ #category : #accessing }
WrappedModel >> meta [
	^ meta
]
