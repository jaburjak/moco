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
	
	self wrapKindsFrom: aModel in: model.
	
	^ model
]

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlModelFactory class >> createMoco: anOpenPonkModel [
	| wrappedModel engine mocoModel |
	wrappedModel := self create: anOpenPonkModel.
	
	mocoModel := MocoWrappedModel new.
	
	engine := MocoTransformationEngine new.

	engine rules add: (MocoOpenPonkOntoUmlKindTransformationRule new).
	
	engine inModel: wrappedModel;
		outModel: mocoModel.
		
	engine transform.
	
	^ mocoModel
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
