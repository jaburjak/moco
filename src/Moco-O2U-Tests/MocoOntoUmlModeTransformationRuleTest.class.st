Class {
	#name : #MocoOntoUmlModeTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlModeTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlModeTransformationRule
]

{ #category : #tests }
MocoOntoUmlModeTransformationRuleTest >> testMode [
	| ou |
	ou := MocoOntoUmlMode new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]
