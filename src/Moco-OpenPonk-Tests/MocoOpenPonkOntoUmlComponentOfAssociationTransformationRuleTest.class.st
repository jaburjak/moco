Class {
	#name : #MocoOpenPonkOntoUmlComponentOfAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlComponentOfAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlComponentOfAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlComponentOfAssociationTransformationRuleTest >> testComponentOf [
	| op m |
	op := OPUMLAssociation new applyStereotype: (OntoUMLComponentOf new essential: true; inseparable: true; yourself); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlComponentOfAssociation ]).
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlSpecializedAssociation ].
	
	self assert: (m essential) equals: true;
		assert: (m inseparable) equals: true
]
