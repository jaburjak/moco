Class {
	#name : #MocoOpenPonkOntoUmlMixinTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlMixinTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlMixinTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlMixinTransformationRuleTest >> testMixin [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLMixin new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlMixin)
]
