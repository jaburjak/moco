Class {
	#name : #MocoUmlMultiValueAttributeTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-U2D-Tests-Rule-Preprocess'
}

{ #category : #execution }
MocoUmlMultiValueAttributeTransformationRuleTest >> execute [
	^ self execute: MocoUmlMultiValueAttributeTransformationRule
]

{ #category : #tests }
MocoUmlMultiValueAttributeTransformationRuleTest >> testDecomposition [
	| attr class class2 association |
	attr := MocoUmlAttribute new name: 'testAttr'; visibility: (MocoUmlVisibility protected); yourself.
	attr type: (MocoUmlType newFromName: 'String').
	attr multiplicity lower value: 2.
	attr multiplicity upper value: 3.
	
	class := MocoUmlClass new name: 'TestClass'; yourself.
	class attributes add: attr.
	
	engine input addElement: class.
	engine addOutputElement: class withSource: class.
	
	self execute.
	
	self assert: (class attributes isEmpty);
		assert: ((engine output elements select: [ :each | each isKindOf: MocoUmlClass ]) size) equals: 2;
		assert: ((engine output elements select: [ :each | each isKindOf: MocoUmlAssociation ]) size) equals: 1.
	
	class2 := engine output elements detect: [ :each | (each isKindOf: MocoUmlClass) and: [ (each == class) not ] ].
	
	self assert: (class2 name) equals: 'TestClass_TestAttr';
		assert: (class2 attributes size) equals: 1;
		assert: (class2 attributes first name) equals: 'value';
		assert: (class2 attributes first type name) equals: (attr type name);
		assert: (class2 attributes first multiplicity lower value) equals: 1;
		assert: (class2 attributes first multiplicity upper value) equals: 1.
	
	association := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association source element) identicalTo: class;
		assert: (association source multiplicity lower value) equals: 1;
		assert: (association source multiplicity upper value) equals: 1;
		assert: (association target element) identicalTo: class2;
		assert: (association target multiplicity lower value) equals: (attr multiplicity lower value);
		assert: (association target multiplicity upper value) equals: (attr multiplicity upper value);
		assert: (association target visibility visibility) equals: (attr visibility visibility);
		assert: (association name) equals: 'testClassTestAttr'
]

{ #category : #tests }
MocoUmlMultiValueAttributeTransformationRuleTest >> testEnumeration [
	| attr class ocl class2 |
	attr := MocoUmlAttribute new name: 'testAttr'; yourself.
	attr type: (MocoUmlType newFromName: 'String').
	attr multiplicity lower value: 2.
	attr multiplicity upper value: 3.
	
	class := MocoUmlClass new.
	class attributes add: attr.
	
	engine input addElement: class.
	engine addOutputElement: class withSource: class.
	
	ocl := MocoOclEnumerationConstraint new context: class; attribute: attr; yourself.
	engine output addElement: ocl.
	
	self execute.
	
	class2 := engine output elements detect: [ :each | (each isKindOf: MocoUmlClass) and: [ (each == class) not ] ].
	
	self assert: (ocl context) identicalTo: class2;
		assert: (ocl attribute) identicalTo: (class2 attributes first)
]

{ #category : #tests }
MocoUmlMultiValueAttributeTransformationRuleTest >> testImmutable [
	| attr class class2 association |
	attr := MocoUmlAttribute new name: 'testAttr'; immutable: true; yourself.
	attr type: (MocoUmlType newFromName: 'String').
	attr multiplicity lower value: 2.
	attr multiplicity upper value: 3.
	
	class := MocoUmlClass new.
	class attributes add: attr.
	
	engine input addElement: class.
	engine addOutputElement: class withSource: class.
	
	self execute.
	
	class2 := engine output elements detect: [ :each | (each isKindOf: MocoUmlClass) and: [ (each == class) not ] ].
	
	self assert: (class2 attributes first immutable) equals: true.
	
	association := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association target frozen) equals: true
]
