"
Represents a UML Class.
"
Class {
	#name : #MocoUmlClass,
	#superclass : #MocoUmlModelElement,
	#instVars : [
		'name',
		'abstract'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlClass >> abstract [
	^ abstract
]

{ #category : #accessing }
MocoUmlClass >> abstract: aBoolean [
	abstract := aBoolean
]

{ #category : #accessing }
MocoUmlClass >> name [
	^ name
]

{ #category : #accessing }
MocoUmlClass >> name: aString [
	name := aString
]
