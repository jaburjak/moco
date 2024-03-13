"
Facade for transforming an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlToUmlFacade,
	#superclass : #Object,
	#category : #'Moco-O2U-Facade'
}

{ #category : #transforming }
MocoOntoUmlToUmlFacade class >> transform: aOntoUmlModel [
	| engine ruleRepo outModel |
	engine := MocoTransformationEngine new.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-O2U';
		rulesTag: 'Rule';
		classPrefix: 'MocoOntoUml'.
	
	ruleRepo injectTo: engine.

	outModel := MocoWrappedModel new.
	
	engine inModel: aOntoUmlModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]
