Class {
	#name : #MocoOpenPonkOntoUmlCategoryTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlCategoryTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlCategoryTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlCategoryTransformationRuleTest >> testCategory [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLCategory new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlCategory)
]
