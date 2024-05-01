Class {
	#name : #MocoOntoUmlCharacterizationAssociationTransformationRuleTest,
	#superclass : #MocoOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlCharacterizationAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlCharacterizationAssociationTransformationRule
]

{ #category : #tests }
MocoOntoUmlCharacterizationAssociationTransformationRuleTest >> testModeSource [
	| mode association mode2 association2 |
	mode := MocoOntoUmlMode new.
	association := MocoOntoUmlCharacterizationAssociation new.
	association source element: mode.
	association target element: (target first).
	
	(engine input) addElement: mode; addElement: association.
	
	mode2 := MocoUmlClass new.
	engine addOutputElement: mode2 withSource: mode.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source element) identicalTo: mode2;
		assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: true
]

{ #category : #tests }
MocoOntoUmlCharacterizationAssociationTransformationRuleTest >> testModeTarget [
	| mode association mode2 association2 |
	mode := MocoOntoUmlMode new.
	association := MocoOntoUmlCharacterizationAssociation new.
	association target element: mode.
	association source element: (source first).
	
	(engine input) addElement: mode; addElement: association.
	
	mode2 := MocoUmlClass new.
	engine addOutputElement: mode2 withSource: mode.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 target element) identicalTo: mode2;
		assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlCharacterizationAssociationTransformationRuleTest >> testQualitySource [
	| quality association quality2 association2 |
	quality := MocoOntoUmlQuality new.
	association := MocoOntoUmlCharacterizationAssociation new.
	association source element: quality.
	association target element: (target first).
	
	(engine input) addElement: quality; addElement: association.
	
	quality2 := MocoUmlClass new.
	engine addOutputElement: quality2 withSource: quality.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source element) identicalTo: quality2;
		assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: true
]

{ #category : #tests }
MocoOntoUmlCharacterizationAssociationTransformationRuleTest >> testQualityTarget [
	| quality association quality2 association2 |
	quality := MocoOntoUmlQuality new.
	association := MocoOntoUmlCharacterizationAssociation new.
	association target element: quality.
	association source element: (source first).
	
	(engine input) addElement: quality; addElement: association.
	
	quality2 := MocoUmlClass new.
	engine addOutputElement: quality2 withSource: quality.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 target element) identicalTo: quality2;
		assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: true
]
