Class {
	#name : #MocoOntoUmlMixinTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlMixinTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlMixinTransformationRule
]

{ #category : #tests }
MocoOntoUmlMixinTransformationRuleTest >> testMixin [
	| ou |
	ou := MocoOntoUmlMixin new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass);
		assert: (engine output elements first abstract) equals: true
]
