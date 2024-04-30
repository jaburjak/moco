Class {
	#name : #MocoOpenPonkOntoUmlRelatorTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlRelatorTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlRelatorTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlRelatorTransformationRuleTest >> testRelator [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLRelator new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlRelator)
]
