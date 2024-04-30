Class {
	#name : #MocoOpenPonkOntoUmlMediationAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlMediationAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlMediationAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlMediationAssociationTransformationRuleTest >> testMediation [
	| op |
	op := OPUMLAssociation new applyStereotype: (OntoUMLMediation new); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlMediationAssociation ])
]
