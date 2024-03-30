"
Transforms enumerations from an OntoUML model to a UML model.
"
Class {
	#name : #MocoOntoUmlEnumerationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #transforming }
MocoOntoUmlEnumerationTransformationRule >> execute [
	| enumerations |
	enumerations := engine input
		selectElementsOfKind: MocoUmlEnumeration
		notGuarded: #MocoOntoUmlEnumerationTransformationRule.
	
	enumerations do: [ :each |
		| copy |
		copy := each deepCopy.
		
		engine addOutputElement: copy withSource: each.
		engine input guard: each with: #MocoOntoUmlEnumerationTransformationRule
	]
]

{ #category : #accessing }
MocoOntoUmlEnumerationTransformationRule >> priority [
	^ 80
]
