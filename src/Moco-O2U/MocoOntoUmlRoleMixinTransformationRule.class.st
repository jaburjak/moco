"
Transforms OntoUML RoleMixin into a UML abstract class.
"
Class {
	#name : #MocoOntoUmlRoleMixinTransformationRule,
	#superclass : #MocoOntoUmlMixinTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlRoleMixinTransformationRule class >> modelSelector [
	^ MocoOntoUmlRoleMixin
]
