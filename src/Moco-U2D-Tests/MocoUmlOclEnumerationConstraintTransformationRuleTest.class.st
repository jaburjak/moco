Class {
	#name : #MocoUmlOclEnumerationConstraintTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'class',
		'table'
	],
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #'private - processing' }
MocoUmlOclEnumerationConstraintTransformationRuleTest >> execute [
	^ self execute: MocoUmlOclEnumerationConstraintTransformationRule
]

{ #category : #running }
MocoUmlOclEnumerationConstraintTransformationRuleTest >> setUp [
	super setUp.
	
	class := MocoUmlClass new name: 'TestClass'; yourself.
	class attributes add: (MocoUmlAttribute new name: 'enumAttr'; type: (MocoUmlType newFromName: 'String'); yourself).
	
	engine input addElement: class.
	
	table := MocoRdbTable new name: 'TEST_CLASS'; yourself.
	table columns add: (MocoRdbColumn new name: 'ENUM_ATTR'; type: (MocoRdbTypeVarchar new); yourself).
	
	engine addOutputElement: table withSource: class
]

{ #category : #tests }
MocoUmlOclEnumerationConstraintTransformationRuleTest >> testOcl [
	| ocl ocl2 |
	ocl := MocoOclEnumerationConstraint new
		name: 'TestOcl';
		context: class;
		attribute: (class attributes first);
		yourself.
	(ocl values) add: 'A'; add: 'B'; add: 'C'.
	
	engine input addElement: ocl.
	
	self execute.
	
	ocl2 := engine output elements select: [ :each | each isKindOf: MocoOclRdbEnumerationConstraint ].
	self assert: (ocl2 size) equals: 1.
	ocl2 := ocl2 first.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoOclEnumerationConstraint ]);
		assert: (ocl2 name) equals: 'TEST_OCL';
		assert: (ocl2 context) identicalTo: table;
		assert: (ocl2 column) identicalTo: (table columns first);
		assert: (ocl2 values) equals: (ocl values)
]
