Class {
	#name : #MocoOntoUmlRelatorTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRelatorTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlRelatorTransformationRule
]

{ #category : #tests }
MocoOntoUmlRelatorTransformationRuleTest >> testRelator [
	| ou |
	ou := MocoOntoUmlRelator new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]
