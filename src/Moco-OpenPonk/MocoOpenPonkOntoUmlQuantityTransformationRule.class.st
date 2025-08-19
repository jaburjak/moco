"
Transforms an OntoUML Collective into its Moco counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlQuantityTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlClassTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlQuantityTransformationRule class >> modelClass [
	^ MocoOntoUmlQuantity
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlQuantityTransformationRule class >> stereotypeSelector [
	^ OntoUMLQuantity
]
