Class {
	#name : #MocoRdbOclImmutableColumnTransformationRuleTest,
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
MocoRdbOclImmutableColumnTransformationRuleTest >> execute [
	^ self execute: MocoRdbOclImmutableColumnTransformationRule
]

{ #category : #running }
MocoRdbOclImmutableColumnTransformationRuleTest >> setUp [
	super setUp.
	
	table := MocoRdbTable new name: 'TEST_TABLE'; yourself.
	column := MocoRdbColumn new name: 'COL'; yourself.
	table columns add: column.
	
	engine input addElement: table
]

{ #category : #tests }
MocoRdbOclImmutableColumnTransformationRuleTest >> testOcl [
	| ocl trigger |
	ocl := MocoOclRdbImmutableColumnCondition new
		name: 'TEST_OCL';
		context: table;
		column: column;
		yourself.
	
	engine input addElement: ocl.
	
	self execute.
	
	trigger := engine output elements select: [ :each | each isKindOf: MocoSqlOracleCreateTrigger ].
	self assert: (trigger size) equals: 1;
		assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL"
BEFORE UPDATE ON "TEST_TABLE" FOR EACH ROW
BEGIN
  IF :old."COL" <> :new."COL" THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'
]
