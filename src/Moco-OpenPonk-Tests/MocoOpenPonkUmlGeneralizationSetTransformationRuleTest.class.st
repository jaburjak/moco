Class {
	#name : #MocoOpenPonkUmlGeneralizationSetTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'members'
	],
	#category : #'Moco-OpenPonk-Tests-Rule-Uml'
}

{ #category : #'private - processing' }
MocoOpenPonkUmlGeneralizationSetTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkUmlGeneralizationSetTransformationRule
]

{ #category : #running }
MocoOpenPonkUmlGeneralizationSetTransformationRuleTest >> setUp [
	super setUp.
	
	members := OrderedCollection
		with: { MocoUmlClass new name: 'G1'; yourself. MocoUmlClass new name: 'S1'; yourself }
		with: { MocoUmlClass new name: 'G2'; yourself. MocoUmlClass new name: 'S2'; yourself }.
	
	members := members collect: [ :each |
		each asOrderedCollection add: (MocoUmlGeneralization new supertype: (each first); subtype: (each second); yourself); yourself
	].

	members do: [ :each |
		each add: (OPUMLClass new name: (each first name); yourself);
			add: (OPUMLClass new name: (each second name); yourself).
		
		each add: (OPUMLGeneralization new general: (each at: 4); specific: (each at: 5); yourself)
	].

	members do: [ :each |
		(engine input) addElement: (each first);
			addElement: (each second);
			addElement: (each at: 3).
		
		engine addOutputElement: (each at: 4) withSource: (each first);
			addOutputElement: (each at: 5) withSource: (each second);
			addOutputElement: (each at: 6) withSource: (each at: 3)
	]
]

{ #category : #tests }
MocoOpenPonkUmlGeneralizationSetTransformationRuleTest >> testCovering [
	| m |
	m := MocoUmlGeneralizationSet new covering: true; yourself.
	
	engine input addElement: m.
	
	self execute.
	
	self assert: ((engine output elements detect: [ :each | each isKindOf: OPUMLGeneralizationSet ]) isCovering) equals: (m covering)
]

{ #category : #tests }
MocoOpenPonkUmlGeneralizationSetTransformationRuleTest >> testDisjoint [
	| m |
	m := MocoUmlGeneralizationSet new disjoint: true; yourself.
	
	engine input addElement: m.
	
	self execute.
	
	self assert: ((engine output elements detect: [ :each | each isKindOf: OPUMLGeneralizationSet ]) isDisjoint) equals: (m disjoint)
]

{ #category : #tests }
MocoOpenPonkUmlGeneralizationSetTransformationRuleTest >> testGeneralizationSet [
	| m op |
	m := MocoUmlGeneralizationSet new name: 'GenSet'; yourself.
	members do: [ :each | m members add: (each at: 3) ].
	
	engine input addElement: m.
	
	self execute.
	
	op := engine output elements select: [ :each | each isKindOf: OPUMLGeneralizationSet ].
	
	self assert: (op size) equals: 1.
	
	op := op first.
	
	self assert: (op name) equals: (m name);
		assert: (op generalizations size) equals: (m members size).
	
	members do: [ :each | self assert: (op generalizations anySatisfy: [ :e | e == (each at: 6) ]) ]
]

{ #category : #tests }
MocoOpenPonkUmlGeneralizationSetTransformationRuleTest >> testIncomplete [
	| m |
	m := MocoUmlGeneralizationSet new covering: false; yourself.
	
	engine input addElement: m.
	
	self execute.
	
	self assert: ((engine output elements detect: [ :each | each isKindOf: OPUMLGeneralizationSet ]) isCovering) equals: (m covering)
]

{ #category : #tests }
MocoOpenPonkUmlGeneralizationSetTransformationRuleTest >> testOverlapping [
	| m |
	m := MocoUmlGeneralizationSet new disjoint: false; yourself.
	
	engine input addElement: m.
	
	self execute.
	
	self assert: ((engine output elements detect: [ :each | each isKindOf: OPUMLGeneralizationSet ]) isDisjoint) equals: (m disjoint)
]
