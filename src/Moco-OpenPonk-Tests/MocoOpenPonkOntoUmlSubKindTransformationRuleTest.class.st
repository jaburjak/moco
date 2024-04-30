Class {
	#name : #MocoOpenPonkOntoUmlSubKindTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlSubKindTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlSubKindTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlSubKindTransformationRuleTest >> testSubKind [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLSubKind new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlSubKind)
]
