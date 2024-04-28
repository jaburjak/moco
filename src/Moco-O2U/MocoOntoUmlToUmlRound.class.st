"
OntoUML model to UML model transformation round.
"
Class {
	#name : #MocoOntoUmlToUmlRound,
	#superclass : #Object,
	#category : #'Moco-O2U-Round'
}

{ #category : #transforming }
MocoOntoUmlToUmlRound class >> transform: aMocoModel withEngineDo: aBlock [
	"Transforms the given OntoUML model to UML."
	
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-O2U';
		rulesTag: 'Rule';
		classPrefix: 'MocoOntoUml'.
	
	ruleRepo injectTo: engine.
	
	aBlock value: engine.
		
	engine transform.
	
	^ engine
]
