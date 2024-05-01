Class {
	#name : #MocoOntoUmlCategoryTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlCategoryTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlCategoryTransformationRule
]

{ #category : #tests }
MocoOntoUmlCategoryTransformationRuleTest >> testCategory [
	| ou |
	ou := MocoOntoUmlCategory new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass);
		assert: (engine output elements first abstract) equals: true
]
