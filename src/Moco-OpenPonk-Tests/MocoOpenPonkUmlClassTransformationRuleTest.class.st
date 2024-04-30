Class {
	#name : #MocoOpenPonkUmlClassTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-OpenPonk-Tests-Rule-Uml'
}

{ #category : #'private - processing' }
MocoOpenPonkUmlClassTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkUmlClassTransformationRule
]

{ #category : #tests }
MocoOpenPonkUmlClassTransformationRuleTest >> testAttribute [
	| m a op |
	m := MocoUmlClass new.
	a := MocoUmlAttribute new
		name: 'testAttr';
		visibility: (MocoUmlVisibility protected);
		immutable: true;
		static: true;
		type: (MocoUmlType newFromName: 'String');
		yourself.
	a multiplicity lower value: 5.
	a multiplicity upper value: 6.
	m attributes add: a.
	
	engine input addElement: m.
	
	self execute.
	
	self assert: (engine output elements first ownedAttributes size) equals: 1.
	
	op := engine output elements first ownedAttributes first.
	
	self assert: (op isKindOf: OPUMLProperty);
		assert: (op name) equals: (a name);
		assert: (op isReadOnly) equals: (a immutable);
		assert: (op isStatic) equals: (a static);
		assert: (op visibility) equals: (a visibility visibility);
		assert: (op type isKindOf: OPUMLPrimitiveType);
		assert: (op type name) equals: 'String'
]

{ #category : #tests }
MocoOpenPonkUmlClassTransformationRuleTest >> testEmpty [
	| m op |
	m := MocoUmlClass new name: 'TestClass'; yourself.
	
	engine input addElement: m.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	op := engine output elements first.
	
	self assert: (op isKindOf: OPUMLClass);
		assert: (op name) equals: (m name)
]

{ #category : #tests }
MocoOpenPonkUmlClassTransformationRuleTest >> testNonPrimitiveAttribute [
	| t m a op |
	t := { MocoUmlClass new name: 'TestType'; yourself. OPUMLClass new name: 'TestType'; yourself }.
	m := MocoUmlClass new name: 'TestClass'; yourself.
	a := MocoUmlAttribute new type: (MocoUmlType newFromName: (t first name)); yourself.
	m attributes add: a.
	
	engine input addElement: (t first).
	engine addOutputElement: (t second) withSource: (t first).
	engine input addElement: m.
	
	self execute.
	
	op := (engine output elements detect: [ :each | (each name) = (m name) ]) ownedAttributes first.
	
	self assert: (op type) identicalTo: (t second)
]
