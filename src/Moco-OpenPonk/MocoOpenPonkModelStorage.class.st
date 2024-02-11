"
Stores a OntoUML model in a globally accessible storage.
"
Class {
	#name : #MocoOpenPonkModelStorage,
	#superclass : #Object,
	#classVars : [
		'OntoUmlModel'
	],
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'as yet unclassified' }
MocoOpenPonkModelStorage class >> ontoUmlModel [
	^ OntoUmlModel
]

{ #category : #accessing }
MocoOpenPonkModelStorage class >> ontoUmlModel: aModel [
	OntoUmlModel := aModel
]
