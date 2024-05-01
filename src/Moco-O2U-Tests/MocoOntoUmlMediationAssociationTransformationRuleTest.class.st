Class {
	#name : #MocoOntoUmlMediationAssociationTransformationRuleTest,
	#superclass : #MocoOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlMediationAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlMediationAssociationTransformationRule
]

{ #category : #tests }
MocoOntoUmlMediationAssociationTransformationRuleTest >> testImmutableSource [
	| relator association relator2 association2 |
	relator := MocoOntoUmlRelator new.
	association := MocoOntoUmlMediationAssociation new.
	association source element: (source first).
	association target element: relator.
	
	(engine input) addElement: relator; addElement: association.
	
	relator2 := MocoUmlClass new.
	engine addOutputElement: relator2 withSource: relator.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source element) identicalTo: (source second);
		assert: (association2 source frozen) equals: true;
		assert: (association2 target element) identicalTo: relator2;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlMediationAssociationTransformationRuleTest >> testImmutableTarget [
	| relator association relator2 association2 |
	relator := MocoOntoUmlRelator new.
	association := MocoOntoUmlMediationAssociation new.
	association source element: relator.
	association target element: (target first).
	
	(engine input) addElement: relator; addElement: association.
	
	relator2 := MocoUmlClass new.
	engine addOutputElement: relator2 withSource: relator.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source element) identicalTo: relator2;
		assert: (association2 source frozen) equals: false;
		assert: (association2 target element) identicalTo: (target second);
		assert: (association2 target frozen) equals: true
]

{ #category : #tests }
MocoOntoUmlMediationAssociationTransformationRuleTest >> testRoleDirection [
	| role relator association role2 relator2 association2 |
	role := MocoOntoUmlRole new.
	relator := MocoOntoUmlRelator new.
	association := MocoOntoUmlMediationAssociation new.
	association source element: role.
	association target element: relator.
	
	(engine input) addElement: role; addElement: relator; addElement: association.
	
	role2 := MocoUmlClass new.
	relator2 := MocoUmlClass new.
	engine addOutputElement: role2 withSource: role;
		addOutputElement: relator2 withSource: relator.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source element) identicalTo: role2;
		assert: (association2 target element) identicalTo: relator2
]

{ #category : #tests }
MocoOntoUmlMediationAssociationTransformationRuleTest >> testRoleDirectionReversal [
	| role relator association role2 relator2 association2 |
	role := MocoOntoUmlRole new.
	relator := MocoOntoUmlRelator new.
	association := MocoOntoUmlMediationAssociation new.
	association source element: relator.
	association target element: role.
	
	(engine input) addElement: role; addElement: relator; addElement: association.
	
	role2 := MocoUmlClass new.
	relator2 := MocoUmlClass new.
	engine addOutputElement: role2 withSource: role;
		addOutputElement: relator2 withSource: relator.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source element) identicalTo: role2;
		assert: (association2 target element) identicalTo: relator2
]
