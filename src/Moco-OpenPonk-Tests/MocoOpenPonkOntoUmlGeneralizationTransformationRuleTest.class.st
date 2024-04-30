Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'general',
		'specific'
	],
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #execution }
MocoOpenPonkOntoUmlGeneralizationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlGeneralizationTransformationRule
]

{ #category : #running }
MocoOpenPonkOntoUmlGeneralizationTransformationRuleTest >> setUp [
	super setUp.
	
	general := { OPUMLClass new name: 'General'; yourself. MocoOntoUmlClass new name: 'General'; yourself }.
	specific := { OPUMLClass new name: 'Specific'; yourself. MocoOntoUmlClass new name: 'Specific'; yourself }.

	engine input addElement: (general first).
	engine input addElement: (specific first).
	
	engine addOutputElement: (general second) withSource: (general first);
		addOutputElement: (specific second) withSource: (specific first).
]

{ #category : #tests }
MocoOpenPonkOntoUmlGeneralizationTransformationRuleTest >> testGeneralization [
	| op m |
	op := OPUMLGeneralization new general: (general first); specific: (specific first); yourself.
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements select: [ :each | each isKindOf: MocoOntoUmlGeneralization ].
	
	self assert: (m size) equals: 1.
	
	m := m first.
	
	self assert: (m supertype) identicalTo: (general second);
		assert: (m subtype) identicalTo: (specific second)
]
