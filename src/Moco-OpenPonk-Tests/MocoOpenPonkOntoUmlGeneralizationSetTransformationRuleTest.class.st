Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'general',
		'members'
	],
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #execution }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlGeneralizationSetTransformationRule
]

{ #category : #running }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest >> setUp [
	super setUp.
	
	general := { OPUMLClass new name: 'Gen'; yourself. MocoOntoUmlClass new name: 'Gen'; yourself }.
	
	engine input addElement: (general first).
	engine addOutputElement: (general second) withSource: (general first).
	
	members := OrderedCollection
		with: { OPUMLClass new name: 'A'; yourself. OPUMLGeneralization new }
		with: { OPUMLClass new name: 'B'; yourself. OPUMLGeneralization new }.

	members := members collect: [ :each |
		| member |
		member := each asOrderedCollection.
		
		(member second) general: (general first);
			specific: (member first).
		
		member add: (MocoOntoUmlClass new name: (member first name); yourself);
			add: (MocoOntoUmlGeneralization new).
		
		(member at: 4) supertype: (general second);
			subtype: (member at: 3).
		
		(engine input) addElement: (member first); addElement: (member second).
		
		engine addOutputElement: (member at: 3) withSource: (member first);
			addOutputElement: (member at: 4) withSource: (member second).
		
		member
	]
]

{ #category : #tests }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest >> testCovering [
	| op m |
	op := OPUMLGeneralizationSet new isCovering: true; yourself.
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlGeneralizationSet ].
	
	self assert: (m covering) equals: (op isCovering)
]

{ #category : #tests }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest >> testDisjoint [
	| op m |
	op := OPUMLGeneralizationSet new isDisjoint: true; yourself.
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlGeneralizationSet ].
	
	self assert: (m disjoint) equals: (op isDisjoint)
]

{ #category : #tests }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest >> testGeneralizationSet [
	| op m |
	op := OPUMLGeneralizationSet new name: 'GenSet'; yourself.
	members do: [ :each | op generalizations add: (each at: 2) ].
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements select: [ :each | each isKindOf: MocoOntoUmlGeneralizationSet ].
	
	self assert: (m size) equals: 1.
	
	m := m first.
	
	self assert: (m name) identicalTo: (op name);
		assert: (m members size) equals: (op generalizations size).
	
	members do: [ :each | self assert: (m members anySatisfy: [ :e | e == (each last) ]) ]
]

{ #category : #tests }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest >> testIncomplete [
	| op m |
	op := OPUMLGeneralizationSet new isCovering: false; yourself.
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlGeneralizationSet ].
	
	self assert: (m covering) equals: (op isCovering)
]

{ #category : #tests }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest >> testOverlapping [
	| op m |
	op := OPUMLGeneralizationSet new isDisjoint: false; yourself.
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlGeneralizationSet ].
	
	self assert: (m disjoint) equals: (op isDisjoint)
]
