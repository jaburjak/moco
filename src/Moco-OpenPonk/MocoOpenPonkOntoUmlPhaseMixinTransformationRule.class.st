"
Transforms an OntoUML PhaseMixin into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlPhaseMixinTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlPhaseMixinTransformationRule class >> modelClass [
	^ MocoOntoUmlPhaseMixin
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlPhaseMixinTransformationRule class >> stereotypeSelector [
	^ OntoUMLPhaseMixin
]
