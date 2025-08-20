Class {
	#name : 'MocoRdbOracleForeignKeyTransformationRuleTest',
	#superclass : 'MocoTransformationRuleTestCase',
	#traits : 'MocoRdbOracleTransformationRuleSqlAssertTrait',
	#classTraits : 'MocoRdbOracleTransformationRuleSqlAssertTrait classTrait',
	#instVars : [
		'table1',
		'table2'
	],
	#category : 'Moco-D2SOracle-Tests-Rule',
	#package : 'Moco-D2SOracle-Tests',
	#tag : 'Rule'
}

{ #category : 'private - processing' }
MocoRdbOracleForeignKeyTransformationRuleTest >> execute [
	^ self execute: MocoRdbOracleForeignKeyTransformationRule
]

{ #category : 'running' }
MocoRdbOracleForeignKeyTransformationRuleTest >> setUp [
	super setUp.

	table1 := MocoRdbTable new name: 'A'; yourself.
	table1 columns add: (MocoRdbColumn new name: 'ID'; type: (MocoRdbTypeInteger new); nullable: false; yourself).
	table1 constraints add: (MocoRdbPrimaryKey new name: 'PK_A'; yourself).
	table1 constraints first columns add: (table1 columns first).
	engine input addElement: table1.
	
	table2 := MocoRdbTable new name: 'B'; yourself.
	table2 columns add: (MocoRdbColumn new name: 'ID'; type: (MocoRdbTypeInteger new); nullable: false; yourself).
	table2 constraints add: (MocoRdbPrimaryKey new name: 'PK_A'; yourself).
	table2 constraints first columns add: (table2 columns first)
]

{ #category : 'tests' }
MocoRdbOracleForeignKeyTransformationRuleTest >> testForeignKey [
	| fk alter |
	fk := MocoRdbForeignKey new name: 'FK_TEST'; yourself.
	table1 columns add: (MocoRdbColumn new name: 'B_ID'; type: (MocoRdbTypeInteger new); yourself).
	fk columns add: (table1 columns last).
	fk referencedTable: table2.
	fk referencedColumns add: (table2 columns first).
	table1 constraints add: fk.
	
	self execute.
	
	alter := engine output elements select: [ :each | each isKindOf: MocoSqlOracleAlterTable ].
	
	self assert: (alter size) equals: 1;
		assert: (alter first table) equals: (table1 name);
		assertSql: (alter first) equals: 'ALTER TABLE "A" ADD CONSTRAINT "FK_TEST" FOREIGN KEY ("B_ID") REFERENCES "B" ("ID") DEFERRABLE INITIALLY DEFERRED;'
]
