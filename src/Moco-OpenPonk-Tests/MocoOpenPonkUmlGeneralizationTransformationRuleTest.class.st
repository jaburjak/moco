Class {
	#name : #MocoOpenPonkUmlGeneralizationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'general',
		'specific'
	],
	#category : #'Moco-OpenPonk-Tests-Rule-Uml'
}

{ #category : #'private - processing' }
MocoOpenPonkUmlGeneralizationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkUmlGeneralizationTransformationRule
]

{ #category : #running }
MocoOpenPonkUmlGeneralizationTransformationRuleTest >> setUp [
	super setUp.
	
	general := { MocoUmlClass new name: 'General'; yourself. OPUMLClass new name: 'General'; yourself }.
	specific := { MocoUmlClass new name: 'Specific'; yourself. OPUMLClass new name: 'Specific'; yourself }.
	
	engine input addElement: (general first).
	engine addOutputElement: (general second) withSource: (general first).
	
	engine input addElement: (specific first).
	engine addOutputElement: (specific second) withSource: (specific first).
]

{ #category : #tests }
MocoOpenPonkUmlGeneralizationTransformationRuleTest >> testGeneralization [
	| m op |
	m := MocoUmlGeneralization new supertype: (general first); subtype: (specific first); yourself.
	
	engine input addElement: m.
	
	self execute.
	
	op := engine output elements select: [ :each | each isKindOf: OPUMLGeneralization ].
	
	self assert: (op size) equals: 1.
	
	op := op first.
	
	self assert: (op general) identicalTo: (general second);
		assert: (op specific) identicalTo: (specific second)
]
