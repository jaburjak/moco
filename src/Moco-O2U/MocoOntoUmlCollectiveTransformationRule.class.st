"
Transforms OntoUML Collective into a UML Class.
"
Class {
	#name : #MocoOntoUmlCollectiveTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlCollectiveTransformationRule class >> modelSelector [
	^ MocoOntoUmlCollective
]

{ #category : #accessing }
MocoOntoUmlCollectiveTransformationRule >> priority [
	^ 100
]
