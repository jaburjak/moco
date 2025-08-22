"
Transformation round realizing a Microsoft SQL Server relational database model in SQL statements.
"
Class {
	#name : 'MocoRdbToSqlMssqlRound',
	#superclass : 'Object',
	#category : 'Moco-D2SMssql-Round',
	#package : 'Moco-D2SMssql',
	#tag : 'Round'
}

{ #category : 'transforming' }
MocoRdbToSqlMssqlRound class >> transform: aMocoModel [
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-D2SMssql';
		rulesTag: 'Rule';
		classPrefix: 'MocoRdbMssql'.
	
	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ engine output
]
