"
Transformation round realizing an PostgreSQL relational database model in SQL statements.
"
Class {
	#name : #MocoRdbToSqlPostgresqlRound,
	#superclass : #Object,
	#category : #'Moco-D2SPostgresql-Round'
}

{ #category : #transforming }
MocoRdbToSqlPostgresqlRound class >> transform: aMocoModel [
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-D2SPostgresql';
		rulesTag: 'Rule';
		classPrefix: 'MocoRdbPostgresql'.
	
	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ engine output
]
