"
Transforms an OntoUML Role into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlRoleTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlRoleTransformationRule class >> modelClass [
	^ MocoOntoUmlRole
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlRoleTransformationRule class >> stereotypeSelector [
	^ OntoUMLRole
]
