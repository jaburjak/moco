Class {
	#name : #MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRuleTest >> testSubQuantityOf [
	| op m |
	op := OPUMLAssociation new applyStereotype: (OntoUMLSubQuantityOf new essential: true; inseparable: true; yourself); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlSubQuantityOfAssociation ]).
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlSpecializedAssociation ].
	
	self assert: (m essential) equals: true;
		assert: (m inseparable) equals: true
]
