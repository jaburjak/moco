"
Transforms an OntoUML Mixin into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlMixinTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlMixinTransformationRule class >> modelClass [
	^ MocoOntoUmlMixin
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlMixinTransformationRule class >> stereotypeSelector [
	^ OntoUMLMixin
]
