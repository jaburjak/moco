"
Transforms OntoUML Category into a UML abstract class.
"
Class {
	#name : #MocoOntoUmlCategoryTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlCategoryTransformationRule class >> modelSelector [
	^ MocoOntoUmlCategory
]

{ #category : #accessing }
MocoOntoUmlCategoryTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoOntoUmlCategoryTransformationRule >> toUmlClass: aMocoOntoUmlCategory [
	| class |
	class := super toUmlClass: aMocoOntoUmlCategory.
	
	class abstract: true.
	
	^ class
]
