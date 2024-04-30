Class {
	#name : #MocoOpenPonkOntoUmlRoleTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlRoleTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlRoleTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlRoleTransformationRuleTest >> testRole [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLRole new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlRole)
]
