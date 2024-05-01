Class {
	#name : #MocoOntoUmlQuantityTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlQuantityTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlQuantityTransformationRule
]

{ #category : #tests }
MocoOntoUmlQuantityTransformationRuleTest >> testQuantity [
	| ou |
	ou := MocoOntoUmlQuantity new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]
