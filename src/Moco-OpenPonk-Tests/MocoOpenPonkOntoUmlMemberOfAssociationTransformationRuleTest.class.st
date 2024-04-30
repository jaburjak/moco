Class {
	#name : #MocoOpenPonkOntoUmlMemberOfAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlMemberOfAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlMemberOfAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlMemberOfAssociationTransformationRuleTest >> testMemberOf [
	| op m |
	op := OPUMLAssociation new applyStereotype: (OntoUMLMemberOf new essential: true; inseparable: true; yourself); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlMemberOfAssociation ]).
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlSpecializedAssociation ].
	
	self assert: (m essential) equals: true;
		assert: (m inseparable) equals: true
]
