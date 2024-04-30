Class {
	#name : #MocoOpenPonkOntoUmlContainmentAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlContainmentAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlContainmentAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlContainmentAssociationTransformationRuleTest >> testContainment [
	| op |
	op := OPUMLAssociation new applyStereotype: (OntoUMLContainment new); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlContainmentAssociation ])
]
