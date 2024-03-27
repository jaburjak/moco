"
Facade for transforming an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlToUmlFacade,
	#superclass : #Object,
	#category : #'Moco-O2U-Facade'
}

{ #category : #transforming }
MocoOntoUmlToUmlFacade class >> transform: aMocoModel [
	"Transforms the given OntoUML model to UML."
	
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-O2U';
		rulesTag: 'Rule';
		classPrefix: 'MocoOntoUml'.
	
	ruleRepo injectTo: engine.
		
	engine transform.
	
	^ engine output
]
