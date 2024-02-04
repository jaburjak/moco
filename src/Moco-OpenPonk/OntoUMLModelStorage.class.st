"
Stores a OntoUML model in a globally accessible storage.
"
Class {
	#name : #OntoUMLModelStorage,
	#superclass : #Object,
	#classVars : [
		'Model'
	],
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'as yet unclassified' }
OntoUMLModelStorage class >> model [
	^ Model
]

{ #category : #accessing }
OntoUMLModelStorage class >> model: aModel [
	Model := aModel
]
