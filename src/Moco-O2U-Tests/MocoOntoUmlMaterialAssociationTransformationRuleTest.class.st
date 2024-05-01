Class {
	#name : #MocoOntoUmlMaterialAssociationTransformationRuleTest,
	#superclass : #MocoOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlMaterialAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlMaterialAssociationTransformationRule
]

{ #category : #tests }
MocoOntoUmlMaterialAssociationTransformationRuleTest >> testNil [
	| association |
	association := MocoOntoUmlMaterialAssociation new.
	association source element: (source first).
	association target element: (target first).
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoUmlAssociation ])
]
