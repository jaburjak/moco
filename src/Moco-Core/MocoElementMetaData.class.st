"
Stores meta data about a WrappedElement.
"
Class {
	#name : #MocoElementMetaData,
	#superclass : #Object,
	#instVars : [
		'outElements',
		'guards',
		'properties'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
MocoElementMetaData >> at: aSymbol [
	^ properties at: aSymbol ifAbsent: [ nil ]
]

{ #category : #accessing }
MocoElementMetaData >> at: aSymbol put: anObject [
	properties at: aSymbol put: anObject
]

{ #category : #testing }
MocoElementMetaData >> checkGuard: aSymbol [
	"Checks whether the given guard symbol is set."
	
	^ guards includes: aSymbol
]

{ #category : #testing }
MocoElementMetaData >> checkNotGuard: aSymbol [
	"Checks whether the given guard symbol is not set."
	
	^ (self checkGuard: aSymbol) not
]

{ #category : #'private - accessing' }
MocoElementMetaData >> guards [
	^ guards
]

{ #category : #initialization }
MocoElementMetaData >> initialize [
	super initialize.
	
	outElements := OrderedCollection new.
	guards := Set new.
	properties := Dictionary new
]

{ #category : #accessing }
MocoElementMetaData >> outElements [
	^ outElements
]

{ #category : #accessing }
MocoElementMetaData >> setGuard: aSymbol [
	"Adds a new guard symbol."
	
	guards add: aSymbol
]
