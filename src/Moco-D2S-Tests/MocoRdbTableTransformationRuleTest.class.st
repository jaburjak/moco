Class {
	#name : #MocoRdbTableTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoRdbTransformationRuleSqlAssertTrait',
	#classTraits : 'MocoRdbTransformationRuleSqlAssertTrait classTrait',
	#category : #'Moco-D2S-Tests-Rule'
}

{ #category : #'private - processing' }
MocoRdbTableTransformationRuleTest >> execute [
	^ self execute: MocoRdbTableTransformationRule
]

{ #category : #tests }
MocoRdbTableTransformationRuleTest >> testTable [
	| table |
	table := MocoRdbTable new name: 'TEST_TABLE'; yourself.
	table columns add: (MocoRdbColumn new name: 'ID'; type: (MocoRdbTypeInteger new); nullable: false; yourself).
	table constraints add: (MocoRdbPrimaryKey new name: 'PK_TEST'; yourself).
	table constraints first columns add: (table columns first).
	table columns add: (MocoRdbColumn new name: 'NAME'; type: (MocoRdbTypeVarchar new length: 42; yourself); nullable: true; yourself).
	table constraints add: (MocoRdbUniqueKey new name: 'UK_NAME'; yourself).
	table constraints second columns add: (table columns second).
	
	engine input addElement: table.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1;
		assert: (engine output elements first isKindOf: MocoSqlOracleCreateTable);
		assertSql: (engine output elements first) equals: 'CREATE TABLE "TEST_TABLE" (
				"ID" NUMBER(38) NOT NULL,
				"NAME" VARCHAR2(42)
			);
			ALTER TABLE "TEST_TABLE" ADD CONSTRAINT "PK_TEST" PRIMARY KEY ("ID");
			ALTER TABLE "TEST_TABLE" ADD CONSTRAINT "UK_NAME" UNIQUE ("NAME");'
]
