Class {
	#name : #MocoOpenPonkOntoUmlModeTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlModeTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlModeTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlModeTransformationRuleTest >> testMode [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLMode new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlMode)
]
