"
Facade for transforming an Oracle relational database model to SQL statements.
"
Class {
	#name : #MocoRdbOracleToSqlFacade,
	#superclass : #Object,
	#category : #'Moco-D2S-Facade'
}

{ #category : #accessing }
MocoRdbOracleToSqlFacade class >> transform: aMocoWrappedModel [
	| engine ruleRepo outModel |
	engine := MocoTransformationEngine new.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-D2S';
		rulesTag: 'Rule';
		classPrefix: 'MocoRdbOracle'.
		
	ruleRepo injectTo: engine.

	outModel := MocoWrappedModel new.
	
	engine inModel: (MocoWrappedModelFactory fromModel: aMocoWrappedModel);
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]
