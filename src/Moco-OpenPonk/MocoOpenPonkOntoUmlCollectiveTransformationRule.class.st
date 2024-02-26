"
Transforms an OntoUML Collective into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlCollectiveTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCollectiveTransformationRule class >> modelClass [
	^ MocoOntoUmlCollective
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCollectiveTransformationRule class >> stereotypeSelector [
	^ OntoUMLCollective
]
