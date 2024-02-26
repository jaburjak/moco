"
Creates a MocoWrappedModel from an OpenPonk OntoUML model.
"
Class {
	#name : #MocoOpenPonkOntoUmlModelFactory,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlModelFactory class >> create: aModel [
	| model |
	model := MocoWrappedModel new.
	
	self
		wrapClassesFrom: aModel in: model;
		wrapAssociationsFrom: aModel in: model.
	
	^ model
]

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlModelFactory class >> createMoco: anOpenPonkModel [
	| wrappedModel engine mocoModel rules |
	wrappedModel := self create: anOpenPonkModel.
	
	mocoModel := MocoWrappedModel new.
	
	engine := MocoTransformationEngine new.
	rules := engine rules.

	rules add: (MocoOpenPonkOntoUmlClassTransformationRule new);
		add: (MocoOpenPonkOntoUmlKindTransformationRule new);
		add: (MocoOpenPonkOntoUmlSubKindTransformationRule new);
		add: (MocoOpenPonkOntoUmlRoleTransformationRule new);
		add: (MocoOpenPonkOntoUmlAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlComponentOfAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlMemberOfAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlContainmentAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlFormalAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlMaterialAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlMediationAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlGeneralizationTransformationRule new).
	
	engine inModel: wrappedModel;
		outModel: mocoModel.
		
	engine transform.
	
	^ mocoModel
]

{ #category : #'as yet unclassified' }
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

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlModelFactory class >> wrapClassesFrom: anOpenPonkModel in: aWrappedModel [
	| classes |
	classes := anOpenPonkModel packagedElements select: [ :e | e isKindOf: OPUMLClass ].
	
	classes do: [ :element |
		| wrappedElement |
		wrappedElement := MocoWrappedElement from: element.
		
		aWrappedModel elements add: wrappedElement.
		
		aWrappedModel meta didChange: true.
	]
]
