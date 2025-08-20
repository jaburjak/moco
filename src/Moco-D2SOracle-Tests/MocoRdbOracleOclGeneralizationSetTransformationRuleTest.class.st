Class {
	#name : 'MocoRdbOracleOclGeneralizationSetTransformationRuleTest',
	#superclass : 'MocoTransformationRuleTestCase',
	#traits : 'MocoRdbOracleTransformationRuleSqlAssertTrait',
	#classTraits : 'MocoRdbOracleTransformationRuleSqlAssertTrait classTrait',
	#instVars : [
		'general',
		'specifics'
	],
	#category : 'Moco-D2SOracle-Tests-Rule',
	#package : 'Moco-D2SOracle-Tests',
	#tag : 'Rule'
}

{ #category : 'private - processing' }
MocoRdbOracleOclGeneralizationSetTransformationRuleTest >> execute [
	^ self execute: MocoRdbOracleOclGeneralizationSetTransformationRule
]

{ #category : 'running' }
MocoRdbOracleOclGeneralizationSetTransformationRuleTest >> setUp [
	super setUp.
	
	general := MocoRdbTable new name: 'GENERAL'; yourself.
	general columns add: (MocoRdbColumn new name: 'GEN_ID'; yourself).
	general columns add: (MocoRdbColumn new name: 'DISCR'; yourself).
	
	engine input addElement: general.
	
	specifics := {
		MocoRdbTable new name: 'A'; yourself.
		MocoRdbTable new name: 'B'; yourself
	}.
	
	specifics do: [ :each |
		each columns add: (MocoRdbColumn new name: (each name , '_ID'); yourself).
		engine input addElement: each
	]
]

{ #category : 'tests' }
MocoRdbOracleOclGeneralizationSetTransformationRuleTest >> testOcl [
	| ocl triggers trigger |
	ocl := MocoOclRdbGeneralizationSetConstraint new
		name: 'TEST_OCL';
		context: general;
		keyColumn: (general columns first);
		discriminatorColumn: (general columns second).
	
	specifics do: [ :each |
		ocl tables add: { each. each columns first }.
		ocl values add: (each name).
		ocl configurations add: (specifics collect: [ :e | e == each ])
	].

	engine input addElement: ocl.
	
	self execute.
	
	triggers := engine output elements select: [ :each | each isKindOf: MocoSqlOracleCreateTrigger ].
	
	self assert: (triggers size) equals: (1 + (3 * (specifics size))).
	
	trigger := triggers select: [ :each | (each table) = (general name) ].
	self assert: (trigger size) equals: 1;
		assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL"
BEFORE INSERT OR UPDATE ON "GENERAL" FOR EACH ROW
DECLARE "l_count" NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE (
    (:new."DISCR" = ''A''
      AND EXISTS (SELECT 1 FROM "A" "a" WHERE "a"."A_ID" = :new."GEN_ID")
      AND NOT EXISTS (SELECT 1 FROM "B" "b" WHERE "b"."B_ID" = :new."GEN_ID"))
    OR (:new."DISCR" = ''B''
      AND NOT EXISTS (SELECT 1 FROM "A" "a" WHERE "a"."A_ID" = :new."GEN_ID")
      AND EXISTS (SELECT 1 FROM "B" "b" WHERE "b"."B_ID" = :new."GEN_ID"))
  );
  IF "l_count" = 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'.
		
	specifics do: [ :each |
		trigger := triggers select: [ :e | ((e table) = (each name)) and: [ (e event) = #INSERT ] ].
		self assert: (trigger size) equals: 1;
			assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL_' , each name , '_INS"
BEFORE INSERT ON "' , each name , '" FOR EACH ROW
DECLARE "l_count" NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE EXISTS (
    SELECT 1 FROM "GENERAL" "g" WHERE "g"."GEN_ID" = :new."' , each columns first name , '");
  IF "l_count" > 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'.
		
		trigger := triggers select: [ :e | ((e table) = (each name)) and: [ (e event) = #UPDATE ] ].
		self assert: (trigger size) equals: 1;
			assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL_' , each name , '_UPD"
BEFORE UPDATE ON "' , each name , '" FOR EACH ROW
DECLARE "l_count" NUMBER := 0;
BEGIN
  IF :old."' , each columns first name , '" <> :new."' , each columns first name , '" THEN
    SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE EXISTS (
      SELECT 1 FROM "GENERAL" "g" WHERE "g"."GEN_ID" = :old."' , each columns first name , '" OR "g"."GEN_ID" = :new."' , each columns first name , '");
  END IF;
  IF "l_count" > 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'.
		
		trigger := triggers select: [ :e | ((e table) = (each name)) and: [ (e event) = #DELETE ] ].
		self assert: (trigger size) equals: 1;
			assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL_' , each name , '_DEL"
BEFORE DELETE ON "' , each name , '" FOR EACH ROW
DECLARE "l_count" NUMBER := 0;
BEGIN
  SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE EXISTS (
    SELECT 1 FROM "GENERAL" "g" WHERE "g"."GEN_ID" = :old."' , each columns first name , '");
  IF "l_count" > 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'
	]
]
