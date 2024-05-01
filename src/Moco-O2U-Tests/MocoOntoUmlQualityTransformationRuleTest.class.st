Class {
	#name : #MocoOntoUmlQualityTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlQualityTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlQualityTransformationRule
]

{ #category : #tests }
MocoOntoUmlQualityTransformationRuleTest >> testQuality [
	| ou |
	ou := MocoOntoUmlQuality new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]
