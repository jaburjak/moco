"
Represents an element visibility.
"
Class {
	#name : #MocoUmlVisibility,
	#superclass : #Object,
	#instVars : [
		'visibility'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #'accessing - enum' }
MocoUmlVisibility class >> private [
	| inst |
	inst := self basicNew.
	inst visibility: #private.
	
	^ inst
]

{ #category : #'accessing - enum' }
MocoUmlVisibility class >> protected [
	| inst |
	inst := self basicNew.
	inst visibility: #protected.
	
	^ inst
]

{ #category : #'accessing - enum' }
MocoUmlVisibility class >> public [
	| inst |
	inst := self basicNew.
	inst visibility: #public.
	
	^ inst
]

{ #category : #initialization }
MocoUmlVisibility >> initialize [
	super initialize.
	
	visibility := #public
]

{ #category : #printing }
MocoUmlVisibility >> printTo: aStream [
	visibility = #public ifTrue: [ aStream nextPutAll: '+' ].
	visibility = #protected ifTrue: [ aStream nextPutAll: '#' ].
	visibility = #private ifTrue: [ aStream nextPutAll: '-' ].
]

{ #category : #accessing }
MocoUmlVisibility >> visibility [
	^ visibility
]

{ #category : #accessing }
MocoUmlVisibility >> visibility: aSymbol [
	aSymbol ifNil: [
		visibility := #public
	] ifNotNil: [
		(#(public protected private) noneSatisfy: [ :each | each = aSymbol ]) ifTrue: [ self error: 'Invalid visibility value.' ].
		
		visibility := aSymbol
	]
]
