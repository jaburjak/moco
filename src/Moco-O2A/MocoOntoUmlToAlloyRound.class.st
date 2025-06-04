"
OntoUML model to Alloy specification transformation round.
"
Class {
	#name : #MocoOntoUmlToAlloyRound,
	#superclass : #Object,
	#category : #'Moco-O2A-Round'
}

{ #category : #transforming }
MocoOntoUmlToAlloyRound class >> transform: aMocoModel [
	"Transforms the given OntoUML model to Alloy."
	| output |

	self transform: aMocoModel withEngineDo: [ :e | output := e output ].
	
	^ output
]

{ #category : #transforming }
MocoOntoUmlToAlloyRound class >> transform: aMocoModel withEngineDo: aBlock [
	"Transforms the given OntoUML model to Alloy."
	
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-O2A';
		rulesTag: 'Rule';
		classPrefix: 'MocoO2A'.
	
	ruleRepo injectTo: engine.
	
	aBlock value: engine.
		
	engine transform.
	
	^ engine
]
