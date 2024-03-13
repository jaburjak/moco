"
Creates a MocoWrappedModel from an OpenPonk OntoUML model.
"
Class {
	#name : #MocoOpenPonkOntoUmlModelFactory,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlModelFactory class >> create: aModel [
	| model |
	model := MocoWrappedModel new.
	
	self
		wrapClassesFrom: aModel in: model;
		wrapAssociationsFrom: aModel in: model.
	
	^ model
]

{ #category : #processing }
MocoOpenPonkOntoUmlModelFactory class >> createMoco: anOpenPonkModel [
	| wrappedModel engine ruleRepo mocoModel |
	wrappedModel := self create: anOpenPonkModel.
	
	mocoModel := MocoWrappedModel new.
	
	engine := MocoTransformationEngine new.
	
	ruleRepo := MocoTransformationRuleDynamicRepository new.
	ruleRepo rulesPackage: 'Moco-OpenPonk';
		rulesTag: 'Rule';
		classPrefix: 'MocoOpenPonkOntoUml'.
	
	ruleRepo injectTo: engine.
	
	engine inModel: wrappedModel;
		outModel: mocoModel.
		
	engine transform.
	
	^ mocoModel
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlModelFactory class >> wrapAssociationsFrom: anOpenPonkModel in: aWrappedModel [
	| associations |
	associations := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLAssociation ].
	
	associations do: [ :element |
		| wrappedElement |
		wrappedElement := MocoWrappedElement from: element.
		
		aWrappedModel elements add: wrappedElement.
		
		aWrappedModel meta didChange: true.
	]
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlModelFactory class >> wrapClassesFrom: anOpenPonkModel in: aWrappedModel [
	| classes |
	classes := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLClass ].
	
	classes do: [ :element |
		| wrappedElement |
		wrappedElement := MocoWrappedElement from: element.
		
		aWrappedModel elements add: wrappedElement.
		
		(element class canUnderstand: #generalizations) ifTrue: [ 
			| sets |
			sets := Set new.
			
			(element generalizations do: [ :each |
				each generalizationSets do: [ :set |
					(aWrappedModel elements contains: [ :e | (e innerElement) == set ]) ifFalse: [
						aWrappedModel elements add: (MocoWrappedElement from: set)
					]
				]
			]).
		].
		
		aWrappedModel meta didChange: true.
	]
]
