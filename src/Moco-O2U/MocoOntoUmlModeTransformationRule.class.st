"
Transforms OntoUML Mode into a UML class.
"
Class {
	#name : #MocoOntoUmlModeTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlModeTransformationRule class >> modelSelector [
	^ MocoOntoUmlMode
]

{ #category : #accessing }
MocoOntoUmlModeTransformationRule >> priority [
	^ 100
]
