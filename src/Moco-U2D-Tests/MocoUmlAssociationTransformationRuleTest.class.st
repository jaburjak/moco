Class {
	#name : #MocoUmlAssociationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'class1',
		'class2'
	],
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRuleTest >> execute [
	^ self execute: MocoUmlAssociationTransformationRule
]

{ #category : #running }
MocoUmlAssociationTransformationRuleTest >> setUp [
	super setUp.
	
	class1 := { MocoUmlClass new name: 'A'; yourself. MocoRdbTable new name: 'A'; yourself }.
	class1 second columns add: (MocoRdbColumn new name: 'A_ID'; type: (MocoRdbTypeInteger new); yourself).
	class1 second constraints add: (MocoRdbPrimaryKey new name: 'PK_A'; yourself).
	class1 second constraints first columns add: (class1 second columns first).
	engine input addElement: (class1 first).
	engine addOutputElement: (class1 second) withSource: (class1 first).
	
	class2 := { MocoUmlClass new name: 'B'; yourself. MocoRdbTable new name: 'B'; yourself }.
	class2 second columns add: (MocoRdbColumn new name: 'B_ID'; type: (MocoRdbTypeInteger new); yourself).
	class2 second constraints add: (MocoRdbPrimaryKey new name: 'PK_B'; yourself).
	class2 second constraints first columns add: (class2 second columns first).
	engine input addElement: (class2 first).
	engine addOutputElement: (class2 second) withSource: (class2 first)
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testImmutableOneToOne [
	| association ocl ocl2 |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 0.
	association source multiplicity upper value: 1.
	association source frozen: true.
	association target element: (class2 first).
	association target multiplicity lower value: 0.
	association target multiplicity upper value: 1.
	
	engine input addElement: association.
	
	self execute.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbImmutableColumnCondition ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl name) equals: 'IM_A_B_ID_UPD';
		assert: (ocl context) identicalTo: (class1 second);
		assert: (ocl column) identicalTo: (class1 second columns second).
	
	ocl2 := engine output elements select: [ :each | each isKindOf: MocoOclRdbImmutableAssociationDeleteCondition ].
	self assert: (ocl2 size) equals: 1.
	ocl2 := ocl2 first.
	
	self assert: (ocl2 name) equals: 'IM_A_B_ID_DEL';
		assert: (ocl2 context) identicalTo: (class1 second);
		assert: (ocl2 column) identicalTo: (class1 second columns second)
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testMandatoryOneToMany [
	| association col |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 1.
	association source multiplicity upper value: 1.
	association target element: (class2 first).
	association target multiplicity lower value: 0.
	association target multiplicity upper value: nil.
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoOclConstraint ] ).
	
	self assert: (class2 second columns size) equals: 2;
		assert: (class2 second constraints size) equals: 2.
	col := class2 second columns second.
	
	self assert: (col name) equals: 'A_ID';
		assert: (col nullable) equals: false
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testOneToImmutableOne [
	| association ocl |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 0.
	association source multiplicity upper value: 1.
	association target element: (class2 first).
	association target multiplicity lower value: 0.
	association target multiplicity upper value: 1.
	association target frozen: true.
	
	engine input addElement: association.
	
	self execute.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbImmutableColumnCondition ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl name) equals: 'IM_A_B_ID_UPD';
		assert: (ocl context) identicalTo: (class1 second);
		assert: (ocl column) identicalTo: (class1 second columns second)
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testOneToMandatoryMany [
	| association col ocl |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 0.
	association source multiplicity upper value: 1.
	association target element: (class2 first).
	association target multiplicity lower value: 1.
	association target multiplicity upper value: nil.
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (class2 second columns size) equals: 2;
		assert: (class2 second constraints size) equals: 2.
	col := class2 second columns second.
	
	self assert: (col name) equals: 'A_ID';
		assert: (col nullable) equals: true.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbMandatoryMultiplicityConstraint ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl name) equals: 'MUL_B_A_ID';
		assert: (ocl context) identicalTo: (class1 second);
		assert: (ocl targetColumn) identicalTo: (class1 second columns first);
		assert: (ocl sourceTable) identicalTo: (class2 second);
		assert: (ocl sourceColumn) identicalTo: col
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testOneToMandatoryOne [
	| association col |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 0.
	association source multiplicity upper value: 1.
	association target element: (class2 first).
	association target multiplicity lower value: 1.
	association target multiplicity upper value: 1.
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoOclConstraint ] ).
	
	self assert: (class1 second columns size) equals: 2;
		assert: (class1 second constraints size) equals: 3.
	
	col := class1 second columns second.
	
	self assert: (col name) equals: 'B_ID';
		assert: (col nullable) equals: false
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testOneToMany [
	| association col fk |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 0.
	association source multiplicity upper value: 1.
	association target element: (class2 first).
	association target multiplicity lower value: 0.
	association target multiplicity upper value: nil.
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoOclConstraint ] ).
	
	self assert: (class2 second columns size) equals: 2;
		assert: (class2 second constraints size) equals: 2.
	col := class2 second columns second.
	fk := class2 second constraints second.
	
	self assert: (col name) equals: 'A_ID';
		assert: (col type isKindOf: MocoRdbTypeInteger);
		assert: (col nullable) equals: true;
		assert: (fk isKindOf: MocoRdbForeignKey);
		assert: (fk name) equals: 'FK_B_A_ID';
		assert: (fk referencedTable) identicalTo: (class1 second);
		assert: (fk referencedColumns size) equals: 1;
		assert: (fk referencedColumns first) identicalTo: (class1 second columns first);
		assert: (fk columns size) equals: 1;
		assert: (fk columns first) identicalTo: col
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testOneToOne [
	| association col fk uq |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 0.
	association source multiplicity upper value: 1.
	association target element: (class2 first).
	association target multiplicity lower value: 0.
	association target multiplicity upper value: 1.
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoOclConstraint ] ).
	
	self assert: (class1 second columns size) equals: 2;
		assert: (class1 second constraints size) equals: 3;
		assert: ((class1 second constraints select: [ :each | each isKindOf: MocoRdbForeignKey ]) size) equals: 1;
		assert: ((class1 second constraints select: [ :each | each isKindOf: MocoRdbUniqueKey ]) size) equals: 1.
	
	col := class1 second columns second.
	fk := class1 second constraints detect: [ :each | each isKindOf: MocoRdbForeignKey ].
	uq := class1 second constraints detect: [ :each | each isKindOf: MocoRdbUniqueKey ].
	
	self assert: (col name) equals: 'B_ID';
		assert: (col type isKindOf: MocoRdbTypeInteger);
		assert: (col nullable) equals: true;
		assert: (fk name) equals: 'FK_A_B_ID';
		assert: (fk referencedTable) identicalTo: (class2 second);
		assert: (fk referencedColumns size) equals: 1;
		assert: (fk referencedColumns first) identicalTo: (class2 second columns first);
		assert: (fk columns size) equals: 1;
		assert: (fk columns first) identicalTo: col;
		assert: (uq name) equals: 'UQ_A_B_ID';
		assert: (uq columns size) equals: 1;
		assert: (uq columns first) identicalTo: col
]

{ #category : #tests }
MocoUmlAssociationTransformationRuleTest >> testSpecialMultiplicity [
	| association col ocl |
	association := MocoUmlAssociation new name: 'testAssoc'; yourself.
	association source element: (class1 first).
	association source multiplicity lower value: 0.
	association source multiplicity upper value: 1.
	association target element: (class2 first).
	association target multiplicity lower value: 3.
	association target multiplicity upper value: 5.
	
	engine input addElement: association.
	
	self execute.
	
	self assert: (class2 second columns size) equals: 2;
		assert: (class2 second constraints size) equals: 2.
	col := class2 second columns second.
	
	self assert: (col name) equals: 'A_ID';
		assert: (col nullable) equals: true.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbSpecialMultiplicityConstraint ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl name) equals: 'MUL_B_A_ID';
		assert: (ocl context) identicalTo: (class1 second);
		assert: (ocl targetColumn) identicalTo: (class1 second columns first);
		assert: (ocl sourceTable) identicalTo: (class2 second);
		assert: (ocl sourceColumn) identicalTo: col;
		assert: (ocl lower) equals: (association target multiplicity lower value);
		assert: (ocl upper) equals: (association target multiplicity upper value)
]
