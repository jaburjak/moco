"
Transforms OntoUML Quantity into UML Class.
"
Class {
	#name : #MocoOntoUmlQuantityTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlQuantityTransformationRule class >> modelSelector [
	^ MocoOntoUmlQuantity
]

{ #category : #accessing }
MocoOntoUmlQuantityTransformationRule >> priority [
	^ 100
]
