"
Represents a OntoUML Kind.
"
Class {
	#name : #MocoOntoUmlKind,
	#superclass : #MocoOntoUmlModelElement,
	#instVars : [
		'name',
		'abstract'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlKind >> abstract [
	^ abstract
]

{ #category : #accessing }
MocoOntoUmlKind >> abstract: aBoolean [
	abstract := aBoolean
]

{ #category : #accessing }
MocoOntoUmlKind >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlKind >> name: aString [
	name := aString
]