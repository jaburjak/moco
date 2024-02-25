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
		wrapKindsFrom: aModel in: model;
		wrapSubKindsFrom: aModel in: model;
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

	rules add: (MocoOpenPonkOntoUmlKindTransformationRule new);
		add: (MocoOpenPonkOntoUmlSubKindTransformationRule new);
		add: (MocoOpenPonkOntoUmlAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlComponentOfAssociationTransformationRule new);
		add: (MocoOpenPonkOntoUmlMemberOfAssociationTransformationRule new).
	
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
MocoOpenPonkOntoUmlModelFactory class >> wrapKindsFrom: anOpenPonkModel in: aWrappedModel [
	| kinds |
	kinds := anOpenPonkModel packagedElements select: [ :e | MocoOpenPonkUmlQuery isElement: e ofStereotype: 'OntoUMLKind' ].
	
	kinds do: [ :element |
		| wrappedElement |
		wrappedElement := MocoWrappedElement from: element.
		
		aWrappedModel elements add: wrappedElement.
		
		aWrappedModel meta didChange: true.
	]
]

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlModelFactory class >> wrapSubKindsFrom: anOpenPonkModel in: aWrappedModel [
	| subkinds |
	subkinds := anOpenPonkModel packagedElements select: [ :e | MocoOpenPonkUmlQuery isElement: e ofStereotype: 'OntoUMLSubKind' ].
	
	subkinds do: [ :element |
		| wrappedElement |
		wrappedElement := MocoWrappedElement from: element.
		
		aWrappedModel elements add: wrappedElement.
		
		aWrappedModel meta didChange: true.
	]
]
