Class {
	#name : #MocoOpenPonkOntoUmlClassTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlClassTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlClassTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlClassTransformationRuleTest >> testAttributes [
	| op m |
	op := OPUMLClass new.
	
	op ownedAttributes add: (OPUMLProperty new
		name: 'myAttr';
		type: (OPUMLClass new name: 'TestType'; yourself);
		visibility: #protected;
		lowerValue: (OPUMLLiteralInteger new value: 3; yourself);
		upperValue: (OPUMLLiteralUnlimitedNatural new value: 4; yourself);
		isReadOnly: true;
		yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first attributes size) equals: 1.
	
	op := op ownedAttributes first.
	m := engine output elements first attributes first.
	
	self assert: (m name) equals: (op name);
		assert: (m type name) equals: (op type name);
		assert: (m multiplicity lower value) equals: (op lowerValue value);
		assert: (m multiplicity upper value) equals: (op upperValue value);
		assert: (m visibility visibility) equals: (op visibility);
		assert: (m immutable) equals: (op isReadOnly)
]

{ #category : #tests }
MocoOpenPonkOntoUmlClassTransformationRuleTest >> testEmpty [
	| op m |
	op := OPUMLClass new.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	m := engine output elements first.
	
	self assert: (m isKindOf: MocoOntoUmlClass);
		assert: (m attributes size) equals: 0
]

{ #category : #tests }
MocoOpenPonkOntoUmlClassTransformationRuleTest >> testName [
	| op |
	op := OPUMLClass new name: 'TestClass'; yourself.
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements first name) equals: (op name)
]
