"
Facade for transforming a UML model to Oracle relational database.
"
Class {
	#name : #MocoUmlToRdbFacade,
	#superclass : #Object,
	#category : #'Moco-U2D-Facade'
}

{ #category : #'private - transforming' }
MocoUmlToRdbFacade class >> preprocess: aUmlModel [
	| engine ruleRepo outModel |
	engine := MocoTransformationEngine new.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-U2D';
		rulesTag: 'Rule-Preprocess';
		classPrefix: 'MocoUml'.

	ruleRepo injectTo: engine.

	outModel := MocoWrappedModel new.
	
	engine inModel: aUmlModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]

{ #category : #accessing }
MocoUmlToRdbFacade class >> transform: aUmlModel [
	| preModel engine ruleRepo outModel |
	preModel := self preprocess: aUmlModel.
	
	outModel := MocoWrappedModel new.
	
	engine := MocoTransformationEngine new.
	
	engine inModel: preModel;
		outModel: outModel.
		
	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-U2D';
		rulesTag: 'Rule';
		classPrefix: 'MocoUml'.
	
	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ { preModel. outModel }.
]
