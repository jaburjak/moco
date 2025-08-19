"
Transforms an OntoUML Mode into its Moco counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlModeTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlClassTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlModeTransformationRule class >> modelClass [
	^ MocoOntoUmlMode
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlModeTransformationRule class >> stereotypeSelector [
	^ OntoUMLMode
]
