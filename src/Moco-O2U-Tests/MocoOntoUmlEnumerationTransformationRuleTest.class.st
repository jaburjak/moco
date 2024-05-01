Class {
	#name : #MocoOntoUmlEnumerationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #execution }
MocoOntoUmlEnumerationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlEnumerationTransformationRule
]

{ #category : #tests }
MocoOntoUmlEnumerationTransformationRuleTest >> testEnumeration [
	| enumeration enumeration2 |
	enumeration := MocoUmlEnumeration new name: 'TestEnum'; yourself.
	(enumeration literals)
		add: (MocoUmlEnumerationLiteral new name: 'First'; yourself);
		add: (MocoUmlEnumerationLiteral new name: 'Second'; yourself).
	
	engine input addElement: enumeration.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1;
		assert: (engine output elements first isKindOf: MocoUmlEnumeration).
	
	enumeration2 := engine output elements first.
	
	self assert: (enumeration2 == enumeration) equals: false;
		assert: (enumeration2 name) equals: (enumeration name);
		assert: (enumeration2 literals size) equals: (enumeration literals size).
	
	enumeration literals do: [ :each | self assert: (enumeration2 literals anySatisfy: [ :e | (e name) = (each name) ]) ]
]
