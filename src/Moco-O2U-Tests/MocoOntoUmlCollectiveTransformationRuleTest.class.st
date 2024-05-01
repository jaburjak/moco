Class {
	#name : #MocoOntoUmlCollectiveTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlCollectiveTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlCollectiveTransformationRule
]

{ #category : #tests }
MocoOntoUmlCollectiveTransformationRuleTest >> testCollective [
	| ou |
	ou := MocoOntoUmlCollective new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]
