"
Transforms an OntoUML Relator into its Moco counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlRelatorTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlClassTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlRelatorTransformationRule class >> modelClass [
	^ MocoOntoUmlRelator
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlRelatorTransformationRule class >> stereotypeSelector [
	^ OntoUMLRelator
]
