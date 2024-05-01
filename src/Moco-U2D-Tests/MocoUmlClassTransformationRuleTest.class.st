Class {
	#name : #MocoUmlClassTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #'private - processing' }
MocoUmlClassTransformationRuleTest >> execute [
	^ self execute: MocoUmlClassTransformationRule
]

{ #category : #tests }
MocoUmlClassTransformationRuleTest >> testAttribute [
	| attr class table col ocl |
	attr := MocoUmlAttribute new name: 'myAttr';
		type: (MocoUmlType newFromName: 'DateTime');
		immutable: true;
		yourself.
	attr multiplicity lower value: 0.
	
	class := MocoUmlClass new name: 'TestClass'; yourself.
	class attributes add: attr.
	
	engine input addElement: class.
	
	self execute.
	
	table := engine output elements select: [ :each | each isKindOf: MocoRdbTable ].
	self assert: (table size) equals: 1.
	table := table first.
	
	self assert: (table columns size) equals: 2;
		assert: (table columns first name) equals: 'TEST_CLASS_ID';
		assert: (table columns second name) equals: 'MY_ATTR'.
	
	col := table columns second.
	
	self assert: (col type isKindOf: MocoRdbTypeDateTime);
		assert: (col nullable) equals: true.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbImmutableColumnCondition ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl name) equals: ('IM_' , table name , '_' , col name , '_UPD');
		assert: (ocl context) identicalTo: table;
		assert: (ocl column) identicalTo: col;
		assert: (ocl operation) equals: #UPDATE
]

{ #category : #tests }
MocoUmlClassTransformationRuleTest >> testEmpty [
	| class table |
	class := MocoUmlClass new name: 'TestClass'; yourself.
	
	engine input addElement: class.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	table := engine output elements first.
	
	self assert: (table isKindOf: MocoRdbTable);
		assert: (table name) equals: 'TEST_CLASS';
		assert: (table columns size) equals: 1;
		assert: (table columns first name) equals: 'TEST_CLASS_ID';
		assert: (table columns first type isKindOf: MocoRdbTypeInteger);
		assert: (table columns first nullable) equals: false;
		assert: (table constraints size) equals: 1;
		assert: (table constraints first isKindOf: MocoRdbPrimaryKey);
		assert: (table constraints first name) equals: 'PK_TEST_CLASS';
		assert: (table constraints first columns size) equals: 1;
		assert: (table constraints first columns first) identicalTo: (table columns first) 
]

{ #category : #tests }
MocoUmlClassTransformationRuleTest >> testIdAttribute [
	| attr class table |
	attr := MocoUmlAttribute new name: 'ID';
		type: (MocoUmlType newFromName: 'Integer');
		yourself.
	
	class := MocoUmlClass new name: 'TestClass'; yourself.
	class attributes add: attr.
	
	engine input addElement: class.
	
	self execute.
	
	table := engine output elements select: [ :each | each isKindOf: MocoRdbTable ].
	self assert: (table size) equals: 1.
	table := table first.
	
	self assert: (table columns size) equals: 1;
		assert: (table columns first name) equals: (attr name)
]
