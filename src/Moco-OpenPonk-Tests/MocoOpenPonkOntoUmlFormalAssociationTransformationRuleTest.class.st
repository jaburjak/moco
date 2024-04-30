Class {
	#name : #MocoOpenPonkOntoUmlFormalAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlFormalAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlFormalAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlFormalAssociationTransformationRuleTest >> testFormal [
	| op |
	op := OPUMLAssociation new applyStereotype: (OntoUMLDomainFormal new); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlFormalAssociation ])
]
