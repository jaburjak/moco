"
Container for WrappedElement instances.
"
Class {
	#name : #MocoWrappedModel,
	#superclass : #Object,
	#instVars : [
		'elements',
		'meta'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
MocoWrappedModel >> elements [
	^ elements
]

{ #category : #initialization }
MocoWrappedModel >> initialize [
	super initialize.
	
	elements := OrderedCollection new.
	meta := MocoModelMetaData new.
]

{ #category : #accessing }
MocoWrappedModel >> meta [
	^ meta
]
