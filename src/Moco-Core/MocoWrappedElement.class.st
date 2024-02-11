"
Wraps a model element with additional meta data.
"
Class {
	#name : #MocoWrappedElement,
	#superclass : #Object,
	#instVars : [
		'innerElement',
		'meta'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #'instance creation' }
MocoWrappedElement class >> from: anElement [
	"Creates a new instance with the given element."
	
	| inst |
	
	inst := self class new.
	inst innerElement: anElement.
	
	^ inst
]

{ #category : #'instance creation' }
MocoWrappedElement class >> new [
	^ self error: 'WrappedElement should only be created using from:'
]

{ #category : #initialization }
MocoWrappedElement >> initialize [
	super initialize.
	
	meta := MocoElementMetaData new.
]

{ #category : #accessing }
MocoWrappedElement >> innerElement [
	^ innerElement
]

{ #category : #accessing }
MocoWrappedElement >> innerElement: anInnerElement [
	innerElement := anInnerElement
]

{ #category : #testing }
MocoWrappedElement >> isWrappingType: aClass [
	"Checks whether the inner element is of the given type."

	^ innerElement isKindOf: aClass
]

{ #category : #initialization }
MocoWrappedElement >> meta [
	^ meta
]
