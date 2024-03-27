"
Facade for transforming an Oracle relational database model to SQL statements.
"
Class {
	#name : #MocoRdbOracleToSqlFacade,
	#superclass : #Object,
	#category : #'Moco-D2S-Facade'
}

{ #category : #transforming }
MocoRdbOracleToSqlFacade class >> transform: aMocoModel [
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
