Class {
	#name : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> createSource [
	^  { OPUMLClass new name: 'source'; yourself. MocoOntoUmlClass new name: 'source'; yourself }
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> createTarget [
	^ { OPUMLClass new name: 'target'; yourself. MocoOntoUmlClass new name: 'target'; yourself }
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlAssociationTransformationRule
]

{ #category : #running }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> setUp [
	super setUp.
	
	source := self createSource.
	target := self createTarget.
	
	engine input addElement: (source first).
	engine input addElement: (target first).
	
	engine addOutputElement: (source second) withSource: (source first);
		addOutputElement: (target second) withSource: (target first)
]

{ #category : #tests }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> testAssociation [
	| op m |
	op := OPUMLAssociation new name: 'AnAssoc';
		isDerived: true.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements select: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m size) equals: 1.
	
	m := m first.
	
	self assert: (m isKindOf: MocoOntoUmlAssociation);
		assert: (m name) equals: (op name);
		assert: (m derived) equals: (op isDerived);
		assert: (m source element) identicalTo: (source second);
		assert: (m target element) identicalTo: (target second)
]

{ #category : #tests }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> testImmutability [
	| op m |
	op := OPUMLAssociation new.
	op memberEnds add: (OPUMLProperty new type: (source first); isReadOnly: true; yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m source frozen) equals: (op memberEnds first isReadOnly);
		assert: (m target frozen) equals: (op memberEnds second isReadOnly)
]

{ #category : #tests }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> testMultiplicity [
	| op m |
	op := OPUMLAssociation new.
	op memberEnds add: (OPUMLProperty new type: (source first); lowerValue: (OPUMLLiteralInteger new value: 4; yourself); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); upperValue: (OPUMLLiteralInteger new value: 6; yourself); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m source multiplicity lower value) equals: (op memberEnds first lowerValue value);
		assert: (m target multiplicity upper value) equals: (op memberEnds second upperValue value)
]

{ #category : #tests }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> testNavigation [
	| op m |
	op := OPUMLAssociation new.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	op navigableOwnedEnds add: (op memberEnds first).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m source navigable) equals: true;
		assert: (m target navigable) equals: false
]

{ #category : #tests }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> testShareability [
	| op m |
	op := OPUMLAssociation new.
	op memberEnds add: (OPUMLProperty new type: (source first); aggregation: #shared; yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); aggregation: #composite; yourself).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m source shareability isShared) equals: true;
		assert: (m target shareability isExclusive) equals: true
]

{ #category : #tests }
MocoOpenPonkOntoUmlAssociationTransformationRuleTest >> testVisibility [
	| op m |
	op := OPUMLAssociation new.
	op memberEnds add: (OPUMLProperty new type: (source first); visibility: #protected; yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); visibility: #private; yourself).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m source visibility visibility) equals: (op memberEnds first visibility);
		assert: (m target visibility visibility) equals: (op memberEnds second visibility)
]
