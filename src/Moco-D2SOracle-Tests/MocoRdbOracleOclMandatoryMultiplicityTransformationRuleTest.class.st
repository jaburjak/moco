Class {
	#name : 'MocoRdbOracleOclMandatoryMultiplicityTransformationRuleTest',
	#superclass : 'MocoTransformationRuleTestCase',
	#traits : 'MocoRdbOracleTransformationRuleSqlAssertTrait',
	#classTraits : 'MocoRdbOracleTransformationRuleSqlAssertTrait classTrait',
	#instVars : [
		'source',
		'target'
	],
	#category : 'Moco-D2SOracle-Tests-Rule',
	#package : 'Moco-D2SOracle-Tests',
	#tag : 'Rule'
}

{ #category : 'private - processing' }
MocoRdbOracleOclMandatoryMultiplicityTransformationRuleTest >> execute [
	^ self execute: MocoRdbOracleOclMandatoryMultiplicityTransformationRule
]

{ #category : 'running' }
MocoRdbOracleOclMandatoryMultiplicityTransformationRuleTest >> setUp [
	super setUp.
	
	source := MocoRdbTable new name: 'A'; yourself.
	source columns add: (MocoRdbColumn new name: 'A_ID'; yourself).
	source columns add: (MocoRdbColumn new name: 'B_ID'; yourself).
	
	engine input addElement: source.
	
	target := MocoRdbTable new name: 'B'; yourself.
	target columns add: (MocoRdbColumn new name: 'B_ID'; yourself).
	
	engine input addElement: target
]

{ #category : 'tests' }
MocoRdbOracleOclMandatoryMultiplicityTransformationRuleTest >> testOcl [
	| ocl triggers trigger |
	ocl := MocoOclRdbMandatoryMultiplicityConstraint new
		name: 'TEST_OCL';
		context: target;
		targetColumn: (target columns first);
		sourceTable: source;
		sourceColumn: (source columns last).
	
	engine input addElement: ocl.
	
	self execute.
	
	triggers := engine output elements select: [ :each | each isKindOf: MocoSqlOracleCreateTrigger ].
	
	self assert: (triggers size) equals: 2.
	
	trigger := triggers select: [ :each | (each table) = (source name) ].
	self assert: (trigger size) equals: 1;
		assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL_REL"
AFTER UPDATE OR DELETE ON "A"
DECLARE "l_count" NUMBER := 0;
BEGIN
  SELECT COUNT(1) INTO "l_count" FROM "B" "b" WHERE 
    NOT EXISTS (SELECT 1 FROM "A" "a" WHERE "a"."B_ID" = "b"."B_ID");
  IF "l_count" > 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'.
	
	trigger := triggers select: [ :each | (each table) = (target name) ].
	self assert: (trigger size) equals: 1;
		assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL"
BEFORE INSERT OR UPDATE ON "B"
FOR EACH ROW
DECLARE
  "l_count" NUMBER := 0;
BEGIN
  SELECT COUNT(1) INTO "l_count" FROM "A" "a" WHERE "a"."B_ID" = :new."B_ID";
  IF "l_count" = 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF;
END;'
]
