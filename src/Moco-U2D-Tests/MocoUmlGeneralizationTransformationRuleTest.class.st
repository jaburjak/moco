Class {
	#name : #MocoUmlGeneralizationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'general',
		'specific'
	],
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #'private - processing' }
MocoUmlGeneralizationTransformationRuleTest >> execute [
	^ self execute: MocoUmlGeneralizationTransformationRule
]

{ #category : #running }
MocoUmlGeneralizationTransformationRuleTest >> setUp [
	super setUp.
	
	general := { MocoUmlClass new name: 'General'; yourself. MocoRdbTable new name: 'GENERAL'; yourself }.
	general second columns add: (MocoRdbColumn new name: 'GENERAL_ID'; type: (MocoRdbTypeInteger new); yourself).
	general second constraints add: (MocoRdbPrimaryKey new name: 'PK_GENERAL_ID'; yourself).
	general second constraints first columns add: (general second columns first).
	engine input addElement: (general first).
	engine addOutputElement: (general second) withSource: (general first).
	
	specific := { MocoUmlClass new name: 'Specific'; yourself. MocoRdbTable new name: 'SPECIFIC'; yourself }.
	specific second columns add: (MocoRdbColumn new name: 'SPECIFIC_ID'; type: (MocoRdbTypeInteger new); yourself).
	specific second constraints add: (MocoRdbPrimaryKey new name: 'PK_SPECIFIC_ID'; yourself).
	specific second constraints first columns add: (specific second columns first).
	engine input addElement: (specific first).
	engine addOutputElement: (specific second) withSource: (specific first)
]

{ #category : #tests }
MocoUmlGeneralizationTransformationRuleTest >> testGeneralization [
	| generalization fk ocl ocl2 |
	generalization := MocoUmlGeneralization new supertype: (general first); subtype: (specific first); yourself.
	engine input addElement: generalization.
	
	self execute.
	
	fk := specific second constraints select: [ :each | each isKindOf: MocoRdbForeignKey ].
	self assert: (fk size) equals: 1.
	fk := fk first.
	
	self assert: (fk name) equals: 'FK_SPECIFIC_GENERAL_ID';
		assert: (fk referencedTable) identicalTo: (general second);
		assert: (fk referencedColumns size) equals: 1;
		assert: (fk referencedColumns first) identicalTo: (general second columns first);
		assert: (fk columns size) equals: 1;
		assert: (fk columns first) identicalTo: (specific second columns first).
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbImmutableColumnCondition ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl name) equals: 'IM_SPECIFIC_SPECIFIC_ID_UPD';
		assert: (ocl context) identicalTo: (specific second);
		assert: (ocl column) identicalTo: (specific second columns first).
	
	ocl2 := engine output elements select: [ :each | each isKindOf: MocoOclRdbImmutableAssociationDeleteCondition ].
	self assert: (ocl2 size) equals: 1.
	ocl2 := ocl2 first.
	
	self assert: (ocl2 name) equals: 'IM_SPECIFIC_SPECIFIC_ID_DEL';
		assert: (ocl2 context) identicalTo: (specific second);
		assert: (ocl2 column) identicalTo: (specific second columns first);
		assert: (ocl2 targetTable) identicalTo: (general second);
		assert: (ocl2 targetColumn) identicalTo: (general second columns first)
]
