Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
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
	
	members := OrderedCollection
		with: { OPUMLClass new name: 'Ag'; yourself. OPUMLClass new name: 'As'; yourself. OPUMLGeneralization new. MocoOntoUmlGeneralization new }
		with: { OPUMLClass new name: 'Bg'; yourself. OPUMLClass new name: 'Bs'; yourself. OPUMLGeneralization new. MocoOntoUmlGeneralization new }.

	members do: [ :each |
		| general specific |
		general := MocoOntoUmlClass new name: ((each at: 1) name); yourself.
		specific := MocoOntoUmlClass new name: ((each at: 2) name); yourself.
		
		engine input addElement: (each at: 1).
		engine addOutputElement: general withSource: (each at: 1).
		engine input addElement: (each at: 2).
		engine addOutputElement: specific withSource: (each at: 2).
		
		(each at: 3) general: (each at: 1);
			specific: (each at: 2).
		
		(each at: 4) supertype: general;
			subtype: specific.
		
		engine input addElement: (each at: 3).
		engine addOutputElement: (each at: 4) withSource: (each at: 3)
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
	members do: [ :each | op generalizations add: (each at: 3) ].
	
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
