Class {
	#name : #MocoOpenPonkOntoUmlQuantityTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlQuantityTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlQuantityTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlQuantityTransformationRuleTest >> testQuantity [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLQuantity new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlQuantity)
]
