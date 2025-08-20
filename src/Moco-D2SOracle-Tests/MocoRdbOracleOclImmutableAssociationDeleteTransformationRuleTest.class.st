Class {
	#name : 'MocoRdbOracleOclImmutableAssociationDeleteTransformationRuleTest',
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
MocoRdbOracleOclImmutableAssociationDeleteTransformationRuleTest >> execute [
	^ self execute: MocoRdbOracleOclImmutableAssociationDeleteTransformationRule
]

{ #category : 'running' }
MocoRdbOracleOclImmutableAssociationDeleteTransformationRuleTest >> setUp [
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
MocoRdbOracleOclImmutableAssociationDeleteTransformationRuleTest >> testOcl [
	| ocl trigger |
	ocl := MocoOclRdbImmutableAssociationDeleteCondition new
		name: 'TEST_OCL';
		context: source;
		column: (source columns last);
		targetTable: target;
		targetColumn: (target columns first).
	
	engine input addElement: ocl.
	
	self execute.
	
	trigger := engine output elements select: [ :each | each isKindOf: MocoSqlOracleCreateTrigger ].
	
	self assert: (trigger size) equals: 1;
		assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL"
BEFORE DELETE ON "A" FOR EACH ROW
DECLARE "l_count" NUMBER;
BEGIN
  SELECT COUNT(1) INTO "l_count" FROM DUAL WHERE EXISTS (
    SELECT 1 FROM "B" "b" WHERE "b"."B_ID" = :old."B_ID");
  IF :old."B_ID" IS NOT NULL AND "l_count" > 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'
]
