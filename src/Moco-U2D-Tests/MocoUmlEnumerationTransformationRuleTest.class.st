Class {
	#name : #MocoUmlEnumerationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'enumeration'
	],
	#category : #'Moco-U2D-Tests-Rule-Preprocess'
}

{ #category : #asserting }
MocoUmlEnumerationTransformationRuleTest >> assertOcl [
	| class attr ocl |
	class := engine output elements detect: [ :each | each isKindOf: MocoUmlClass ].
	attr := class attributes first.

	ocl := engine output elements select: [ :each | each isKindOf: MocoOclEnumerationConstraint ].
	
	self assert: (ocl size) equals: 1.
	
	ocl := ocl first.
	
	self assert: (ocl values size) equals: (enumeration literals size);
		assert: (ocl name) equals: ('EN_' , class name , '_' , attr name);
		assert: (ocl context) identicalTo: class;
		assert: (ocl attribute) identicalTo: attr.
	
	enumeration literals do: [ :each | self assert: (ocl values includes: (each name)) ]
]

{ #category : #'private - processing' }
MocoUmlEnumerationTransformationRuleTest >> execute [
	^ self execute: MocoUmlEnumerationTransformationRule
]

{ #category : #running }
MocoUmlEnumerationTransformationRuleTest >> setUp [
	super setUp.
	
	enumeration := MocoUmlEnumeration new name: 'TestEnum'; yourself.
	
	(enumeration literals)
		add: (MocoUmlEnumerationLiteral new name: 'First'; yourself);
		add: (MocoUmlEnumerationLiteral new name: 'Second'; yourself).
	
	engine input addElement: enumeration.
	engine addOutputElement: enumeration withSource: enumeration
]

{ #category : #tests }
MocoUmlEnumerationTransformationRuleTest >> testAssociation [
	| class assoc |
	class := MocoUmlClass new.
	
	assoc := MocoUmlAssociation new name: 'test'; yourself.
	assoc source element: class.
	assoc target element: enumeration.
	assoc target multiplicity lower value: 3.
	assoc target multiplicity upper value: 4.
	
	(engine output) addElement: class; addElement: assoc.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoUmlAssociation ]);
		assert: (class attributes size) equals: 1;
		assert: (class attributes first name) equals: (assoc name);
		assert: (class attributes first multiplicity lower value) equals: (assoc target multiplicity lower value);
		assert: (class attributes first multiplicity upper value) equals: (assoc target multiplicity upper value);
		assert: (class attributes first type name) equals: 'String';
		assertOcl
]

{ #category : #tests }
MocoUmlEnumerationTransformationRuleTest >> testAttribute [
	| attr class |
	attr := MocoUmlAttribute new.
	attr type: (MocoUmlType newFromName: (enumeration name)).
	
	class := MocoUmlClass new.
	class attributes add: attr.
	
	engine output addElement: class.
	
	self execute.
	
	self assert: (attr type name) equals: 'String';
		assertOcl
]
