Class {
	#name : #MocoOntoUmlRoleMixinTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRoleMixinTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlRoleMixinTransformationRule
]

{ #category : #tests }
MocoOntoUmlRoleMixinTransformationRuleTest >> testRoleMixin [
	| ou |
	ou := MocoOntoUmlRoleMixin new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass);
		assert: (engine output elements first abstract) equals: true
]
