Class {
	#name : #MocoOntoUmlClassTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlClassTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlClassTransformationRule
]

{ #category : #tests }
MocoOntoUmlClassTransformationRuleTest >> testAttribute [
	| ou attr u |
	ou := MocoOntoUmlClass new.
	
	attr := MocoOntoUmlAttribute new
		name: 'testAttr';
		static: true;
		immutable: true;
		visibility: (MocoUmlVisibility protected);
		type: (MocoUmlType newFromName: 'TestType').
	attr multiplicity lower value: 3.
	attr multiplicity upper value: 4.
	
	ou attributes add: attr.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first attributes size) equals: 1.
	
	u := engine output elements first attributes first.
	
	self assert: (u isKindOf: MocoUmlAttribute);
		assert: (u name) equals: (attr name);
		assert: (u static) equals: (attr static);
		assert: (u immutable) equals: (attr immutable);
		assert: (u type name) equals: (attr type name);
		assert: (u visibility visibility) equals: (attr visibility visibility);
		assert: (u multiplicity lower value) equals: (attr multiplicity lower value);
		assert: (u multiplicity upper value) equals: (attr multiplicity upper value)
]

{ #category : #tests }
MocoOntoUmlClassTransformationRuleTest >> testEmpty [
	| ou |
	ou := MocoOntoUmlClass new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1;
		assert: (engine output elements first isKindOf: MocoUmlClass)
]

{ #category : #tests }
MocoOntoUmlClassTransformationRuleTest >> testName [
	| ou |
	ou := MocoOntoUmlClass new name: 'TestClass'; abstract: true; yourself.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first name) equals: (ou name);
		assert: (engine output elements first abstract) equals: (ou abstract)
]
