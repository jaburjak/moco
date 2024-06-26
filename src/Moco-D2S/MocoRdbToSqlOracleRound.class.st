"
Transformation round realizing an Oracle relational database model in SQL statements.
"
Class {
	#name : #MocoRdbToSqlOracleRound,
	#superclass : #Object,
	#category : #'Moco-D2S-Round'
}

{ #category : #transforming }
MocoRdbToSqlOracleRound class >> transform: aMocoModel [
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-D2S';
		rulesTag: 'Rule';
		classPrefix: 'MocoRdb'.
	
	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ engine output
]
