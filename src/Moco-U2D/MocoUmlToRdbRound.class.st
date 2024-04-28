"
Transformation round of an UML model to Oracle relational database.
"
Class {
	#name : #MocoUmlToRdbRound,
	#superclass : #Object,
	#category : #'Moco-U2D-Round'
}

{ #category : #'private - transforming' }
MocoUmlToRdbRound class >> preprocess: aMocoModel [
	"Creates a preprocessed UML model suitable for transformation to an RDB model."
	
	| engine ruleRepo |
	engine := MocoTransformationEngine new.

	engine input addElements: aMocoModel.

	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-U2D';
		rulesTag: 'Rule-Preprocess';
		classPrefix: 'MocoUml'.

	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ engine output
]

{ #category : #transforming }
MocoUmlToRdbRound class >> transform: aMocoModel [
	"Transforms the given UML model to a relational database model."
	
	| preModel engine ruleRepo |
	preModel := self preprocess: aMocoModel.
	
	engine := MocoTransformationEngine new.
	
	engine input addElements: preModel keepMeta: #(generatedBy).
		
	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-U2D';
		rulesTag: 'Rule';
		classPrefix: 'MocoUml'.
	
	ruleRepo injectTo: engine.
	
	engine transform.
	
	^ { preModel. engine output }
]
