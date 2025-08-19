"
Transforms an OntoUML Quality into its Moco counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlQualityTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlClassTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlQualityTransformationRule class >> modelClass [
	^ MocoOntoUmlQuality
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlQualityTransformationRule class >> stereotypeSelector [
	^ OntoUMLQuality
]
