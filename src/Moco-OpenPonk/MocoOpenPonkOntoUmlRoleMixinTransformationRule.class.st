"
Transforms an OntoUML RoleMixin into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlRoleMixinTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlRoleMixinTransformationRule class >> modelClass [
	^ MocoOntoUmlRoleMixin
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlRoleMixinTransformationRule class >> stereotypeSelector [
	^ OntoUMLRoleMixin
]
