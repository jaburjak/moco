"
Creates a MocoWrappedModel from an OpenPonk OntoUML model.
"
Class {
	#name : #MocoOpenPonkOntoUmlModelFactory,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlModelFactory class >> addAssociations: anOpenPonkModel to: aMocoModel [
	"Adds associations from an OpenPonk model to the given Moco model."
	
	| associations |
	associations := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLAssociation ].
	
	associations do: [ :each | aMocoModel addElement: each ]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlModelFactory class >> addClasses: anOpenPonkModel to: aMocoModel [
	"Adds classes from the given OpenPonk model to the given Moco model."
	
	| classes |
	classes := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLClass ].
	
	classes do: [ :each | aMocoModel addElement: each ]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlModelFactory class >> addElements: anOpenPonkModel to: aMocoModel [
	"Adds elements from the given OpenPonk model to the given Moco model."
	
	self
		addClasses: anOpenPonkModel to: aMocoModel;
		addAssociations: anOpenPonkModel to: aMocoModel;
		addGeneralizationSets: anOpenPonkModel to: aMocoModel;
		addEnumerations: anOpenPonkModel to: aMocoModel.
	
	^ aMocoModel
]

{ #category : #adding }
MocoOpenPonkOntoUmlModelFactory class >> addEnumerations: anOpenPonkModel to: aMocoModel [
	"Adds enumerations from the given OpenPonk model to the given Moco model."
	
	| enumerations |
	enumerations := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLEnumeration ].
	
	enumerations do: [ :each | aMocoModel addElement: each ]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlModelFactory class >> addGeneralizationSets: anOpenPonkModel to: aMocoModel [
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
MocoOpenPonkOntoUmlModelFactory class >> createMoco: anOpenPonkModel [
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
