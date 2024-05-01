Class {
	#name : #MocoOntoUmlContainmentAssociationTransformationRuleTest,
	#superclass : #MocoOntoUmlPartWholeAssociationTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlContainmentAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlContainmentAssociationTransformationRule
]

{ #category : #tests }
MocoOntoUmlContainmentAssociationTransformationRuleTest >> testQuantitySource [
	| quantity association quantity2 association2 |
	quantity := MocoOntoUmlQuantity new.
	association := MocoOntoUmlContainmentAssociation new.
	association source element: quantity.
	association target element: (target first).
	
	(engine input) addElement: quantity; addElement: association.
	
	quantity2 := MocoUmlClass new.
	engine addOutputElement: quantity2 withSource: quantity.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: true
]

{ #category : #tests }
MocoOntoUmlContainmentAssociationTransformationRuleTest >> testQuantityTarget [
	| quantity association quantity2 association2 |
	quantity := MocoOntoUmlQuantity new.
	association := MocoOntoUmlContainmentAssociation new.
	association source element: (source first).
	association target element: quantity.
	
	(engine input) addElement: quantity; addElement: association.
	
	quantity2 := MocoUmlClass new.
	engine addOutputElement: quantity2 withSource: quantity.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: false
]
