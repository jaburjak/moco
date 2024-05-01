Class {
	#name : #MocoUmlMediatingClassOptimizationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #'private - processing' }
MocoUmlMediatingClassOptimizationTransformationRuleTest >> execute [
	^ self execute: MocoUmlMediatingClassOptimizationTransformationRule
]

{ #category : #tests }
MocoUmlMediatingClassOptimizationTransformationRuleTest >> testOptimization [
	| class table pk |
	class := MocoUmlClass new.
	table := MocoRdbTable new.
	
	table columns add: (MocoRdbColumn new name: 'ID'; yourself).
	table constraints add: (MocoRdbPrimaryKey new name: 'PK'; yourself).
	table constraints first columns add: (table columns first).
	
	table columns add: (MocoRdbColumn new name: 'FK'; yourself).
	table constraints add: (MocoRdbForeignKey new name: 'FK'; yourself).
	table constraints second columns add: (table columns second).
	
	(engine input) addElement: class; metaOf: class at: #generatedBy put: #MocoUmlManyToManyAssociationTransformationRule.
	engine addOutputElement: table withSource: class.
	
	self execute.
	
	self assert: (table columns size) equals: 1.
	
	pk := table constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ].
	self assert: (pk size) equals: 1.
	pk := pk first.
	
	self assert: (pk columns size) equals: 1;
		assert: (pk columns first) identicalTo: (table columns first)
]
