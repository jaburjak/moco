"
Transforms OntoUML Mixin into a UML abstract class.
"
Class {
	#name : #MocoOntoUmlMixinTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlMixinTransformationRule class >> modelSelector [
	^ MocoOntoUmlMixin
]

{ #category : #accessing }
MocoOntoUmlMixinTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoOntoUmlMixinTransformationRule >> toUmlClass: aMocoOntoUmlMixin [
	| class |
	class := super toUmlClass: aMocoOntoUmlMixin.
	
	class abstract: true.
	
	^ class
]
