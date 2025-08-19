"
Stores a OntoUML model in a globally accessible storage.
"
Class {
	#name : 'MocoOpenPonkModelStorage',
	#superclass : 'Object',
	#classVars : [
		'OntoUmlModel'
	],
	#category : 'Moco-OpenPonk-Utils',
	#package : 'Moco-OpenPonk',
	#tag : 'Utils'
}

{ #category : 'accessing' }
MocoOpenPonkModelStorage class >> ontoUmlModel [
	"Retrieves a model from the storage."
	
	^ OntoUmlModel
]

{ #category : 'accessing' }
MocoOpenPonkModelStorage class >> ontoUmlModel: aModel [
	"Stores the given model."
	
	OntoUmlModel := aModel
]
