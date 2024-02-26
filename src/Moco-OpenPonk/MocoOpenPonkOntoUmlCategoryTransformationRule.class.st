"
Transforms an OntoUML Category into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlCategoryTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCategoryTransformationRule class >> modelClass [
	^ MocoOntoUmlCategory
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCategoryTransformationRule class >> stereotypeSelector [
	^ OntoUMLCategory
]
