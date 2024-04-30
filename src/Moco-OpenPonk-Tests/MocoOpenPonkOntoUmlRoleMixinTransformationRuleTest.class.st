Class {
	#name : #MocoOpenPonkOntoUmlRoleMixinTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlRoleMixinTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlRoleMixinTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlRoleMixinTransformationRuleTest >> testRoleMixin [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLRoleMixin new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlRoleMixin)
]
