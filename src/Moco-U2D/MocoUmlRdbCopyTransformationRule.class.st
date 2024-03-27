"
Copies UML model elements without transformations.
"
Class {
	#name : #MocoUmlRdbCopyTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #transforming }
MocoUmlRdbCopyTransformationRule >> execute [
	"Copies all elements from the input model to the output model."
	
	| elements |
	elements := engine input selectElementsNotGuarded: #MocoUmlRdbCopyTransformationRule.

	elements do: [ :each |
		engine addOutputElement: (each deepCopy) withSource: each.
		engine input guard: each with: #MocoUmlRdbCopyTransformationRule
	]
]

{ #category : #accessing }
MocoUmlRdbCopyTransformationRule >> priority [
	^ 50
]
