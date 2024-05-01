Class {
	#name : #MocoOntoUmlGeneralizationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'general',
		'specific'
	],
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #execution }
MocoOntoUmlGeneralizationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlGeneralizationTransformationRule
]

{ #category : #running }
MocoOntoUmlGeneralizationTransformationRuleTest >> setUp [
	super setUp.
	
	general := { MocoOntoUmlClass new. MocoUmlClass new }.
	specific := { MocoOntoUmlClass new. MocoUmlClass new }.
	
	(engine input) addElement: (general first); addElement: (specific first).
	
	engine addOutputElement: (general second) withSource: (general first);
		addOutputElement: (specific second) withSource: (specific first)
]

{ #category : #tests }
MocoOntoUmlGeneralizationTransformationRuleTest >> testGeneralization [
	| generalization generalization2 |
	generalization := MocoOntoUmlGeneralization new supertype: (general first); subtype: (specific first); yourself.
	
	engine input addElement: generalization.
	
	self execute.
	
	generalization2 := engine output elements select: [ :each | each isKindOf: MocoUmlGeneralization ].
	self assert: (generalization2 size) equals: 1.
	generalization2 := generalization2 first.
	
	self assert: (generalization2 supertype) identicalTo: (general second);
		assert: (generalization2 subtype) identicalTo: (specific second)
]
