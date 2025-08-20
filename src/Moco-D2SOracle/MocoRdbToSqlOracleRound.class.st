"
Transformation round realizing an Oracle relational database model in SQL statements.
"
Class {
	#name : 'MocoRdbToSqlOracleRound',
	#superclass : 'Object',
	#category : 'Moco-D2SOracle-Round',
	#package : 'Moco-D2SOracle',
	#tag : 'Round'
}

{ #category : 'transforming' }
MocoRdbToSqlOracleRound class >> transform: aMocoModel [
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-D2SOracle';
		rulesTag: 'Rule';
		classPrefix: 'MocoRdbOracle'.
	
	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ engine output
]
