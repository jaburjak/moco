"
Transforms an OntoUML Phase into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlPhaseTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlPhaseTransformationRule class >> modelClass [
	^ MocoOntoUmlPhase
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlPhaseTransformationRule class >> stereotypeSelector [
	^ OntoUMLPhase
]
