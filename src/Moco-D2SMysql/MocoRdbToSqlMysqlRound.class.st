"
Transformation round realizing an PostgreSQL relational database model in SQL statements.
"
Class {
	#name : 'MocoRdbToSqlMysqlRound',
	#superclass : 'Object',
	#category : 'Moco-D2SMysql-Round',
	#package : 'Moco-D2SMysql',
	#tag : 'Round'
}

{ #category : 'transforming' }
MocoRdbToSqlMysqlRound class >> transform: aMocoModel [
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-D2SMysql';
		rulesTag: 'Rule';
		classPrefix: 'MocoRdbMysql'.
	
	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ engine output
]
