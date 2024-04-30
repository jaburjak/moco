Class {
	#name : #MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRuleTest >> testSubCollectionOf [
	| op m |
	op := OPUMLAssociation new applyStereotype: (OntoUMLSubCollectionOf new essential: true; inseparable: true; yourself); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlSubCollectionOfAssociation ]).
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlSpecializedAssociation ].
	
	self assert: (m essential) equals: true;
		assert: (m inseparable) equals: true
]
