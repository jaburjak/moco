"
Stores meta data about a WrappedElement.
"
Class {
	#name : #MocoElementMetaData,
	#superclass : #Object,
	#instVars : [
		'outElements',
		'processedBy'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #initialization }
MocoElementMetaData >> initialize [
	super initialize.
	
	outElements := OrderedCollection new.
	processedBy := OrderedCollection new.
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
