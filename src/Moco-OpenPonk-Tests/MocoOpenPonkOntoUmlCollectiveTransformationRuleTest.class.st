Class {
	#name : #MocoOpenPonkOntoUmlCollectiveTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlCollectiveTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlCollectiveTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlCollectiveTransformationRuleTest >> testCollective [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLCollective new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlCollective)
]
