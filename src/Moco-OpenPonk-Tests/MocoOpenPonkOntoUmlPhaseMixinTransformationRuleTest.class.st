Class {
	#name : #MocoOpenPonkOntoUmlPhaseMixinTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlPhaseMixinTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlPhaseMixinTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlPhaseMixinTransformationRuleTest >> testPhaseMixin [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLPhaseMixin new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlPhaseMixin)
]
