Class {
	#name : #MocoOntoUmlAssociationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlAssociationTransformationRule
]

{ #category : #running }
MocoOntoUmlAssociationTransformationRuleTest >> setUp [
	super setUp.
	
	source := { MocoOntoUmlClass new. MocoUmlClass new }.
	target := { MocoOntoUmlClass new. MocoUmlClass new }.
	
	(engine input) addElement: (source first); addElement: (target first).
	
	engine addOutputElement: (source second) withSource: (source first);
		addOutputElement: (target second) withSource: (target first)
]

{ #category : #tests }
MocoOntoUmlAssociationTransformationRuleTest >> testAssociation [
	| association association2 |
	association := MocoOntoUmlAssociation new name: 'testAssociation'; yourself.
	
	(association source) name: 'source';
		element: (source first);
		frozen: true.
	
	(association target) name: 'target';
		element: (target first).
	association target multiplicity lower value: 4.
	association target multiplicity upper value: 5.
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements select: [ :each | each isKindOf: MocoUmlAssociation ].
	self assert: (association2 size) equals: 1.
	association2 := association2 first.
	
	self assert: (association2 name) equals: (association name);
		assert: (association2 source element) identicalTo: (source second);
		assert: (association2 source name) equals: (association source name);
		assert: (association2 source frozen) equals: (association source frozen);
		assert: (association2 target element) identicalTo: (target second);
		assert: (association2 target name) equals: (association target name);
		assert: (association2 target multiplicity lower value) equals: (association target multiplicity lower value);
		assert: (association2 target multiplicity upper value) equals: (association target multiplicity upper value)
]

{ #category : #tests }
MocoOntoUmlAssociationTransformationRuleTest >> testFormal [
	| association |
	association := MocoOntoUmlFormalAssociation new.
	association source element: (source first).
	association target element: (target first).
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoUmlAssociation ])
]
