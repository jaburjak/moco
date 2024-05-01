"
Copies UML model elements without transformations.
"
Class {
	#name : #MocoUmlCopyTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #transforming }
MocoUmlCopyTransformationRule >> execute [
	"Copies all elements from the input model to the output model."
	
	| elements |
	elements := engine input selectElementsNotGuarded: #MocoUmlCopyTransformationRule.

	elements do: [ :each |
		engine addOutputElement: (each deepCopy) withSource: each.
		engine input guard: each with: #MocoUmlCopyTransformationRule
	]
]

{ #category : #accessing }
MocoUmlCopyTransformationRule >> priority [
	^ 50
]
