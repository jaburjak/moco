"
Stores a OntoUML model in a globally accessible storage.
"
Class {
	#name : #MocoOntoUmlModelStorage,
	#superclass : #Object,
	#classVars : [
		'Model'
	],
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'as yet unclassified' }
MocoOntoUmlModelStorage class >> model [
	^ Model
]

{ #category : #accessing }
MocoOntoUmlModelStorage class >> model: aModel [
	Model := aModel
]
