Class {
	#name : #MocoOpenPonkUmlEnumerationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-OpenPonk-Tests-Rule-Uml'
}

{ #category : #'private - processing' }
MocoOpenPonkUmlEnumerationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkUmlEnumerationTransformationRule
]

{ #category : #tests }
MocoOpenPonkUmlEnumerationTransformationRuleTest >> testEnumeration [
	| m op |
	m := MocoUmlEnumeration new name: 'TestEnum'; yourself.
	m literals add: (MocoUmlEnumerationLiteral new name: 'First'; yourself).
	m literals add: (MocoUmlEnumerationLiteral new name: 'Second'; yourself).
	
	engine input addElement: m.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	op := engine output elements first.
	
	self assert: (op isKindOf: OPUMLEnumeration);
		assert: (op name) equals: (m name);
		assert: (op ownedLiterals size) equals: (m literals size).
	
	m literals do: [ :each | self assert: (op ownedLiterals anySatisfy: [ :e | (e name) = (each name) ]) ]
]
