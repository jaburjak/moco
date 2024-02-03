"
Wraps a model element with additional meta data.
"
Class {
	#name : #WrappedElement,
	#superclass : #Object,
	#instVars : [
		'innerElement',
		'meta'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #'instance creation' }
WrappedElement class >> from: anElement [
	"Creates a new instance with the given element."
	
	| inst |
	
	inst := self class new.
	inst innerElement: anElement.
	
	^ inst
]

{ #category : #'instance creation' }
WrappedElement class >> new [
	^ self error: 'WrappedElement should only be created using from:'
]

{ #category : #initialization }
WrappedElement >> initialize [
	super initialize.
	
	meta := ElementMetaData new.
]

{ #category : #accessing }
WrappedElement >> innerElement [
	^ innerElement
]

{ #category : #accessing }
WrappedElement >> innerElement: anInnerElement [
	innerElement := anInnerElement
]

{ #category : #testing }
WrappedElement >> isWrappingType: aClass [
	"Checks whether the inner element is of the given type."

	^ innerElement isKindOf: aClass
]

{ #category : #initialization }
WrappedElement >> meta [
	^ meta
]
