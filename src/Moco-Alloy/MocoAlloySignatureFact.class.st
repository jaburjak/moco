"
Represents a signature fact in an Alloy specification.
"
Class {
	#name : #MocoAlloySignatureFact,
	#superclass : #Object,
	#instVars : [
		'body'
	],
	#category : #'Moco-Alloy-Model'
}

{ #category : #accessing }
MocoAlloySignatureFact >> body [
	^ body
]

{ #category : #accessing }
MocoAlloySignatureFact >> body: aString [
	body := aString
]

{ #category : #initialization }
MocoAlloySignatureFact >> initialize [
	super initialize.

	body := ''
]

{ #category : #printing }
MocoAlloySignatureFact >> printTo: aStream [
	aStream nextPutAll: body
]
