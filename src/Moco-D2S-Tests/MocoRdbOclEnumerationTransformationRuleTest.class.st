Class {
	#name : #MocoRdbOclEnumerationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoRdbTransformationRuleSqlAssertTrait',
	#classTraits : 'MocoRdbTransformationRuleSqlAssertTrait classTrait',
	#instVars : [
		'table',
		'column'
	],
	#category : #'Moco-D2S-Tests-Rule'
}

{ #category : #'private - processing' }
MocoRdbOclEnumerationTransformationRuleTest >> execute [
	^ self execute: MocoRdbOclEnumerationTransformationRule
]

{ #category : #running }
MocoRdbOclEnumerationTransformationRuleTest >> setUp [
	super setUp.
	
	table := MocoRdbTable new name: 'TEST_TABLE'; yourself.
	column := MocoRdbColumn new name: 'ENUM'; type: (MocoRdbTypeVarchar new); nullable: false; yourself.
	table columns add: column
]

{ #category : #tests }
MocoRdbOclEnumerationTransformationRuleTest >> testOcl [
	| ocl alter |
	ocl := MocoOclRdbEnumerationConstraint new
		name: 'TEST_OCL';
		context: table;
		column: column;
		yourself.
	
	(ocl values) add: 'X'; add: 'Y'; add: 'Z'.
	
	engine input addElement: ocl.
	
	self execute.
	
	alter := engine output elements select: [ :each | each isKindOf: MocoSqlOracleAlterTable ].
	
	self assert: (alter size) equals: 1;
		assert: (alter first table) equals: (table name);
		assertSql: (alter first) equals: 'ALTER TABLE "TEST_TABLE" ADD CONSTRAINT "EN_TEST_TABLE_ENUM" CHECK
			("ENUM"=''X'' OR "ENUM"=''Y'' OR "ENUM"=''Z'');'
]
