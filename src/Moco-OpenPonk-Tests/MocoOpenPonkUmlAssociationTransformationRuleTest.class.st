Class {
	#name : #MocoOpenPonkUmlAssociationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moco-OpenPonk-Tests-Rule-Uml'
}

{ #category : #'private - processing' }
MocoOpenPonkUmlAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkUmlAssociationTransformationRule
]

{ #category : #running }
MocoOpenPonkUmlAssociationTransformationRuleTest >> setUp [
	super setUp.
	
	source := { MocoUmlClass new name: 'source'; yourself. OPUMLClass new name: 'source'; yourself }.
	target := { MocoUmlClass new name: 'target'; yourself. OPUMLClass new name: 'target'; yourself }.
	
	engine input addElement: (source first).
	engine addOutputElement: (source second) withSource: (source first).
	
	engine input addElement: (target first).
	engine addOutputElement: (target second) withSource: (target first).
]

{ #category : #tests }
MocoOpenPonkUmlAssociationTransformationRuleTest >> testAssociation [
	| m s t op |
	m := MocoUmlAssociation new name: 'testAssoc'; derived: true; yourself.
	s := MocoUmlAssociationSide new name: 'source';
		frozen: true;
		visibility: (MocoUmlVisibility protected);
		aggregation: (MocoUmlAssociationAggregation composite);
		element: (source first);
		navigable: true.
	s multiplicity lower value: 3.
	s multiplicity upper value: 4.
	t := MocoUmlAssociationSide new name: 'target';
		visibility: (MocoUmlVisibility private);
		aggregation: (MocoUmlAssociationAggregation shared);
		element: (target first).
	t multiplicity lower value: 0.
	t multiplicity upper value: nil.
	m source: s; target: t.
	
	engine input addElement: m.
	
	self execute.
	
	op := engine output elements select: [ :each | each isKindOf: OPUMLAssociation ].
	
	self assert: (op size) equals: 1.
	
	op := op first.
	
	self assert: (op name) equals: (m name);
		assert: (op isDerived) equals: (m derived);
		assert: (op memberEnds size) equals: 2;
		assert: (op memberEnds first name) equals: (s name);
		assert: (op memberEnds first isReadOnly) equals: (s frozen);
		assert: (op memberEnds first visibility) equals: (s visibility visibility);
		assert: (op memberEnds first aggregation) equals: (s aggregation type);
		assert: (op memberEnds first lowerValue value) equals: (s multiplicity lower value);
		assert: (op memberEnds first upperValue value) equals: (s multiplicity upper value);
		assert: (op memberEnds first type) identicalTo: (source second);
		assert: (op memberEnds second name) equals: (t name);
		assert: (op memberEnds second visibility) equals: (t visibility visibility);
		assert: (op memberEnds second aggregation) equals: (t aggregation type);
		assert: (op memberEnds second lowerValue value) equals: (t multiplicity lower value);
		assert: (op memberEnds second upperValue value) equals: '*';
		assert: (op navigableOwnedEnds size) equals: 1;
		assert: (op navigableOwnedEnds first) identicalTo: (op memberEnds first)
]
