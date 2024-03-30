"
Represents an enumeration literal in a UML model.
"
Class {
	#name : #MocoUmlEnumerationLiteral,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #initialization }
MocoUmlEnumerationLiteral >> initialize [
	super initialize.
	
	name := ''
]

{ #category : #accessing }
MocoUmlEnumerationLiteral >> name [
	^ name
]

{ #category : #accessing }
MocoUmlEnumerationLiteral >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #printing }
MocoUmlEnumerationLiteral >> printTo: aStream [
	aStream nextPutAll: name
]
