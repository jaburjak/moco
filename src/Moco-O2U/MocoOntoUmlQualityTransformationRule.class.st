"
Transforms OntoUML Quality into a UML class.
"
Class {
	#name : #MocoOntoUmlQualityTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlQualityTransformationRule class >> modelSelector [
	^ MocoOntoUmlQuality
]

{ #category : #accessing }
MocoOntoUmlQualityTransformationRule >> priority [
	^ 100
]
