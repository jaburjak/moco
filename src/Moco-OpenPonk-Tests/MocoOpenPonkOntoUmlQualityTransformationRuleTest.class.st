Class {
	#name : #MocoOpenPonkOntoUmlQualityTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlQualityTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlQualityTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlQualityTransformationRuleTest >> testQuality [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLQuality new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlQuality)
]
