Class {
	#name : #MocoOntoUmlPhaseMixinTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlPhaseMixinTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlPhaseMixinTransformationRule
]

{ #category : #tests }
MocoOntoUmlPhaseMixinTransformationRuleTest >> testPhaseMixin [
	| ou |
	ou := MocoOntoUmlPhaseMixin new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass);
		assert: (engine output elements first abstract) equals: true
]
