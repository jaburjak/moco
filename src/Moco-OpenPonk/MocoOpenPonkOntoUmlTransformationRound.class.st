"
Transforms an OpenPonk OntoUML model to a Moco OntoUML model.
"
Class {
	#name : #MocoOpenPonkOntoUmlTransformationRound,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Round'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlTransformationRound class >> addAssociations: anOpenPonkModel to: aMocoModel [
	"Adds associations from an OpenPonk model to the given Moco model."
	
	| associations |
	associations := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLAssociation ].
	
	associations do: [ :each | aMocoModel addElement: each ]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlTransformationRound class >> addClasses: anOpenPonkModel to: aMocoModel [
	"Adds classes from the given OpenPonk model to the given Moco model."
	
	| classes |
	classes := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLClass ].
	
	classes do: [ :each | aMocoModel addElement: each ]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlTransformationRound class >> addElements: anOpenPonkModel to: aMocoModel [
	"Adds elements from the given OpenPonk model to the given Moco model."
	
	self
		addClasses: anOpenPonkModel to: aMocoModel;
		addAssociations: anOpenPonkModel to: aMocoModel;
		addGeneralizationSets: anOpenPonkModel to: aMocoModel;
		addEnumerations: anOpenPonkModel to: aMocoModel.
	
	^ aMocoModel
]

{ #category : #adding }
MocoOpenPonkOntoUmlTransformationRound class >> addEnumerations: anOpenPonkModel to: aMocoModel [
	"Adds enumerations from the given OpenPonk model to the given Moco model."
	
	| enumerations |
	enumerations := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLEnumeration ].
	
	enumerations do: [ :each | aMocoModel addElement: each ]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlTransformationRound class >> addGeneralizationSets: anOpenPonkModel to: aMocoModel [
	"Adds generalization sets from the given OpenPonk model to the given Moco model."
	
	| classes |
	classes := anOpenPonkModel packagedElements select: [ :e | (e isKindOf: OPUMLClass) and: [ e class canUnderstand: #generalizations ] ].
	
	classes do: [ :each |
		| sets |
		sets := Set new.
		
		(each generalizations do: [ :generalization |
			generalization generalizationSets do: [ :set |
				(aMocoModel elements noneSatisfy: [ :e | e == set ]) ifTrue: [
					aMocoModel addElement: set
				]
			]
		]).
	]
]

{ #category : #transforming }
MocoOpenPonkOntoUmlTransformationRound class >> createMoco: anOpenPonkModel [
	"Creates a Moco OntoUML model from the given OpenPonk OntoUML model."
	
	| engine ruleRepo |
	engine := MocoTransformationEngine new.
	
	self addElements: anOpenPonkModel to: (engine input).
	
	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-OpenPonk';
		rulesTag: 'Rule';
		classPrefix: 'MocoOpenPonkOntoUml'.
	
	ruleRepo injectTo: engine.
		
	engine transform.
	
	^ engine output
]
