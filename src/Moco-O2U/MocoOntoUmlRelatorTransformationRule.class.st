"
Transforms OntoUML Relator into a UML Class.
"
Class {
	#name : #MocoOntoUmlRelatorTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlRelatorTransformationRule class >> modelSelector [
	^ MocoOntoUmlRelator
]

{ #category : #accessing }
MocoOntoUmlRelatorTransformationRule >> priority [
	^ 100
]
