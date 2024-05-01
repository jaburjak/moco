Class {
	#name : #MocoUmlNonNativeRdbTypeTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-U2D-Tests-Rule-Preprocess'
}

{ #category : #execution }
MocoUmlNonNativeRdbTypeTransformationRuleTest >> execute [
	^ self execute: MocoUmlNonNativeRdbTypeTransformationRule
]

{ #category : #tests }
MocoUmlNonNativeRdbTypeTransformationRuleTest >> testDecomposition [
	| type attr class association |
	type := MocoUmlClass new name: 'String'; yourself.
	engine input addElement: type.
	engine addOutputElement: type withSource: type.
	
	attr := MocoUmlAttribute new name: 'testAttr';
		type: (MocoUmlType newFromName: (type name));
		visibility: (MocoUmlVisibility protected);
		yourself.
	attr multiplicity lower value: 2.
	attr multiplicity upper value: 3.
	
	class := MocoUmlClass new name: 'TestClass'; yourself.
	class attributes add: attr.
	
	engine input addElement: class.
	engine addOutputElement: class withSource: class.
	
	self execute.
	
	self assert: (class attributes isEmpty).
	
	association := engine output elements select: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association size) equals: 1.
	
	association := association first.
	
	self assert: (association source element) identicalTo: class;
		assert: (association source multiplicity lower value) equals: 0;
		assert: (association source multiplicity upper value) equals: nil;
		assert: (association target element) identicalTo: type;
		assert: (association target name) equals: (attr name);
		assert: (association target visibility visibility) equals: (attr visibility visibility);
		assert: (association target multiplicity lower value) equals: (attr multiplicity lower value);
		assert: (association target multiplicity upper value) equals: (attr multiplicity upper value);
		assert: (association name) equals: 'testClassTestAttr'
]

{ #category : #tests }
MocoUmlNonNativeRdbTypeTransformationRuleTest >> testEnumeration [
	| type attr class association |
	type := MocoUmlEnumeration new name: 'TestEnum'; yourself.
	engine input addElement: type.
	engine addOutputElement: type withSource: type.
	
	attr := MocoUmlAttribute new type: (MocoUmlType newFromName: (type name)); yourself.
	
	class := MocoUmlClass new.
	class attributes add: attr.
	
	engine input addElement: class.
	engine addOutputElement: class withSource: class.
	
	self execute.
	
	association := engine output elements select: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association size) equals: 1;
		assert: (association first target element) identicalTo: type
]

{ #category : #tests }
MocoUmlNonNativeRdbTypeTransformationRuleTest >> testImmutability [
	| type attr class association |
	type := MocoUmlClass new name: 'String'; yourself.
	engine input addElement: type.
	engine addOutputElement: type withSource: type.
	
	attr := MocoUmlAttribute new type: (MocoUmlType newFromName: (type name)); immutable: true; yourself.
	
	class := MocoUmlClass new.
	class attributes add: attr.
	
	engine input addElement: class.
	engine addOutputElement: class withSource: class.
	
	self execute.
	
	association := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association target frozen) equals: true
]
