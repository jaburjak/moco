Class {
	#name : #MocoRdbOclExclusiveAssociationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoRdbTransformationRuleSqlAssertTrait',
	#classTraits : 'MocoRdbTransformationRuleSqlAssertTrait classTrait',
	#instVars : [
		'target',
		'sources'
	],
	#category : #'Moco-D2S-Tests-Rule'
}

{ #category : #'private - processing' }
MocoRdbOclExclusiveAssociationTransformationRuleTest >> execute [
	^ self execute: MocoRdbOclExclusiveAssociationTransformationRule
]

{ #category : #running }
MocoRdbOclExclusiveAssociationTransformationRuleTest >> setUp [
	super setUp.
	
	target := MocoRdbTable new name: 'TARGET'; yourself.
	target columns add: (MocoRdbColumn new name: 'TARGET_ID'; type: (MocoRdbTypeInteger new); nullable: false; yourself).
	target constraints add: (MocoRdbPrimaryKey new name: 'PK_TARGET'; yourself).
	target constraints first columns add: (target columns first).
	engine input addElement: target.
	
	sources := {
		OrderedCollection with: (MocoRdbTable new name: 'A'; yourself).
		OrderedCollection with: (MocoRdbTable new name: 'B'; yourself)
	}.
	
	sources do: [ :each |
		each first columns add: (MocoRdbColumn new name: (each first name , '_ID'); type: (MocoRdbTypeInteger new); nullable: false; yourself).
		each first constraints add: (MocoRdbPrimaryKey new name: ('PK_' , each first name); yourself).
		each first constraints first columns add: (target columns first).
		
		each first columns add: (MocoRdbColumn new name: (target columns first name); type: (MocoRdbTypeInteger new); yourself).
		each first constraints add: (MocoRdbForeignKey new name: ('FK_' , each first name , '_', each first columns second name); yourself).
		each first constraints last columns add: (each first columns last).
		each first constraints last referencedTable: target.
		each first constraints last referencedColumns add: (target columns first).
		
		engine input addElement: (each first)
	]
]

{ #category : #tests }
MocoRdbOclExclusiveAssociationTransformationRuleTest >> testOcl [
	| ocl triggers trigger |
	ocl := MocoOclRdbExclusiveAssociationCondition new
		name: 'TEST_OCL';
		context: target;
		column: (target columns first);
		yourself.
	
	sources do: [ :each | ocl referencingTables add: ({ each first }). ocl referencingColumns add: ({ each first columns last }) ].
	
	engine input addElement: ocl.
	
	self execute.
	
	triggers := engine output elements select: [ :each | each isKindOf: MocoSqlOracleCreateTrigger ].
	self assert: (triggers size) equals: 1 + (sources size * 2).
	
	trigger := triggers select: [ :each | (each name) = (ocl name) ].
	self assert: (trigger size) equals: 1;
		assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL"
BEFORE INSERT OR UPDATE ON "TARGET" FOR EACH ROW
DECLARE "l_count" NUMBER;
BEGIN
  SELECT COUNT(1) INTO "l_count" FROM DUAL WHERE (
    (EXISTS (SELECT 1 FROM "A" "a" WHERE "a"."TARGET_ID" = :new."TARGET_ID")
      AND NOT EXISTS (SELECT 1 FROM "B" "b" WHERE "b"."TARGET_ID" = :new."TARGET_ID"))
    OR (NOT EXISTS (SELECT 1 FROM "A" "a" WHERE "a"."TARGET_ID" = :new."TARGET_ID")
      AND EXISTS (SELECT 1 FROM "B" "b" WHERE "b"."TARGET_ID" = :new."TARGET_ID")));
  IF "l_count" = 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'.

	sources do: [ :each |
		| other |
		
		trigger := triggers select: [ :e | (e time = #BEFORE) and: [ (e table) = (each first name) ] ].
		self assert: (trigger size) equals: 1.
		
		other := sources detect: [ :e | (e == each) not ].
		
		self assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL_' , each first name , '_INS"
BEFORE INSERT ON "' , each first name , '" FOR EACH ROW
DECLARE "l_count" NUMBER;
BEGIN
  SELECT COUNT(1) INTO "l_count" FROM DUAL WHERE (
    EXISTS (SELECT 1 FROM "' , other first name , '" "' , other first name asLowercase , '" WHERE "' , other first name asLowercase , '"."TARGET_ID" = :new."TARGET_ID"));
  IF "l_count" > 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'.

		trigger := triggers select: [ :e | (e time = #AFTER) and: [ (e table) = (each first name) ] ].
		self assert: (trigger size) equals: 1.
		
		self assertSql: (trigger first) equals: 'CREATE TRIGGER "TEST_OCL_' , each first name , '_UPD_DEL"
AFTER UPDATE OR DELETE ON "' , each first name , '"
DECLARE "l_count" NUMBER;
BEGIN
  SELECT COUNT(1) INTO "l_count" FROM "TARGET" "t" WHERE NOT (
    (EXISTS (SELECT 1 FROM "A" "a" WHERE "a"."TARGET_ID" = "t"."TARGET_ID")
      AND NOT EXISTS (SELECT 1 FROM "B" "b" WHERE "b"."TARGET_ID" = "t"."TARGET_ID"))
    OR (NOT EXISTS (SELECT 1 FROM "A" "a" WHERE "a"."TARGET_ID" = "t"."TARGET_ID")
      AND EXISTS (SELECT 1 FROM "B" "b" WHERE "b"."TARGET_ID" = "t"."TARGET_ID")));
  IF "l_count" > 0 THEN
    raise_application_error(-20101, ''OCL constraint TEST_OCL violated!'');
  END IF; END;'
	]
]
