Class {
	#name : #MocoOpenPonkOntoUmlPhaseTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlPhaseTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlPhaseTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlPhaseTransformationRuleTest >> testPhase [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLPhase new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlPhase)
]
