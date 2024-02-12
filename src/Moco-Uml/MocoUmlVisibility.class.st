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
	visibility := aSymbol
]
