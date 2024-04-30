Class {
	#name : #MocoOpenPonkOntoUmlKindTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlKindTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlKindTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlKindTransformationRuleTest >> testKind [
	| op |
	op := OPUMLClass new applyStereotype: (OntoUMLKind new); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoOntoUmlKind)
]
