"
Stores meta data about a WrappedElement.
"
Class {
	#name : #MocoElementMetaData,
	#superclass : #Object,
	#instVars : [
		'outElements',
		'processedBy',
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

{ #category : #initialization }
MocoElementMetaData >> initialize [
	super initialize.
	
	outElements := OrderedCollection new.
	processedBy := OrderedCollection new.
	properties := Dictionary new
]

{ #category : #testing }
MocoElementMetaData >> isNotProcessedBy: anObject [
	^ (self isProcessedBy: anObject) not
]

{ #category : #testing }
MocoElementMetaData >> isProcessedBy: anObject [
	^ processedBy includes: anObject
]

{ #category : #accessing }
MocoElementMetaData >> markProcessedBy: anObject [
	processedBy add: anObject
]

{ #category : #accessing }
MocoElementMetaData >> outElements [
	^ outElements
]

{ #category : #'private - accessing' }
MocoElementMetaData >> processedBy [
	^ processedBy
]
