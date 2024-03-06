"
Transforms OntoUML PhaseMixin into a UML abstract class.
"
Class {
	#name : #MocoOntoUmlPhaseMixinTransformationRule,
	#superclass : #MocoOntoUmlMixinTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlPhaseMixinTransformationRule class >> modelSelector [
	^ MocoOntoUmlPhaseMixin
]
