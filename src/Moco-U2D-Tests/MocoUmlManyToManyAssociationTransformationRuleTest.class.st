Class {
	#name : #MocoUmlManyToManyAssociationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'class1',
		'class2'
	],
	#category : #'Moco-U2D-Tests-Rule-Preprocess'
}

{ #category : #'private - processing' }
MocoUmlManyToManyAssociationTransformationRuleTest >> execute [
	^ self execute: MocoUmlManyToManyAssociationTransformationRule
]

{ #category : #running }
MocoUmlManyToManyAssociationTransformationRuleTest >> setUp [
	super setUp.
	
	class1 := MocoUmlClass new name: 'A'; yourself.
	class2 := MocoUmlClass new name: 'B'; yourself.
	
	(engine output) addElement: class1; addElement: class2
]

{ #category : #tests }
MocoUmlManyToManyAssociationTransformationRuleTest >> testDecomposition [
	| association class associations |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: class1.
	association source multiplicity lower value: 2.
	association source multiplicity upper value: 3.
	association target element: class2.
	association target multiplicity lower value: 4.
	association target multiplicity upper value: 5.
	
	engine output addElement: association.
	
	self execute.
	
	self assert: ((engine output elements select: [ :each | each isKindOf: MocoUmlClass ]) size) equals: 3.
	
	class := engine output elements select: [ :each | (each isKindOf: MocoUmlClass) and: [ (each name) = ((class1 name) , '_TestAssoc_' , (class2 name)) ] ].
	
	self assert: (class size) equals: 1.
	
	class := class first.
	
	self assert: (engine output metaOf: class at: #generatedBy) equals: #MocoUmlManyToManyAssociationTransformationRule.
	
	associations := engine output elements select: [ :each | (each isKindOf: MocoUmlAssociation) and: [ each anySideIncludes: class ] ].
	
	self assert: (associations size) equals: 2;
		assert: (((engine output elements select: [ :each | each isKindOf: MocoUmlAssociation ]) select: [ :each | (each source multiplicity upper isMultiple) and: [ each target multiplicity upper isMultiple ] ]) size) equals: 0
]

{ #category : #tests }
MocoUmlManyToManyAssociationTransformationRuleTest >> testEmptyName [
	| association |
	association := MocoUmlAssociation new.
	association source element: class1.
	association source multiplicity lower value: 2.
	association source multiplicity upper value: 3.
	association target element: class2.
	association target multiplicity lower value: 4.
	association target multiplicity upper value: 5.
	
	engine output addElement: association.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | (each isKindOf: MocoUmlClass) and: [ (each name) = ((class1 name) , '_To_' , (class2 name)) ] ])
]

{ #category : #tests }
MocoUmlManyToManyAssociationTransformationRuleTest >> testSideNames [
	| association |
	association := MocoUmlAssociation new.
	association source element: class1.
	association source name: 'X'.
	association source multiplicity lower value: 2.
	association source multiplicity upper value: 3.
	association target element: class2.
	association target name: 'Y'.
	association target multiplicity lower value: 4.
	association target multiplicity upper value: 5.
	
	engine output addElement: association.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | (each isKindOf: MocoUmlClass) and: [ (each name) = 'X_To_Y' ] ])
]
