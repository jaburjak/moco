"
Transforms an OntoUML Quality into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlQualityTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlQualityTransformationRule class >> modelClass [
	^ MocoOntoUmlQuality
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlQualityTransformationRule class >> stereotypeSelector [
	^ OntoUMLQuality
]
