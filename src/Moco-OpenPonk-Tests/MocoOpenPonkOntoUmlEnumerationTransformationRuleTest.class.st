Class {
	#name : #MocoOpenPonkOntoUmlEnumerationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #execution }
MocoOpenPonkOntoUmlEnumerationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlEnumerationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlEnumerationTransformationRuleTest >> testEnumeration [
	| op m |
	op := OPUMLEnumeration new name: 'TestEnum'; yourself.
	op ownedLiterals add: (OPUMLEnumerationLiteral new name: 'First'; yourself).
	op ownedLiterals add: (OPUMLEnumerationLiteral new name: 'Second'; yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	m := engine output elements first.
	
	self assert: (m isKindOf: MocoUmlEnumeration);
		assert: (m literals size) equals: 2;
		assert: (m literals anySatisfy: [ :each | (each name) = (op ownedLiterals first name) ] );
		assert: (m literals anySatisfy: [ :each | (each name) = (op ownedLiterals second name) ] )
]
