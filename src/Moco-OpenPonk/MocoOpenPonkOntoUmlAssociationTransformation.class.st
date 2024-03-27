"
Contains methods for transforming OpenPonk OntoUML associations to Moco OntoUML associations.
"
Class {
	#name : #MocoOpenPonkOntoUmlAssociationTransformation,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#category : #'Moco-OpenPonk-Transformation'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlAssociationTransformation class >> engine: aMocoTransformationEngine [
	| inst |
	inst := self new.
	
	inst engine: aMocoTransformationEngine.
	
	^ inst
]

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationTransformation class >> toMocoShareability: aSymbol [
	"Transforms association shareability type from an OpenPonk model to Moco representation."
	
	aSymbol
		ifNil: [ ^ MocoOntoUmlAssociationShareability new. ]
		ifNotNil: [
			(aSymbol = #composite)
				ifTrue: [ ^ MocoOntoUmlAssociationShareability exclusive. ]
				ifFalse: [
					(aSymbol = #shared) ifTrue: [ ^ MocoOntoUmlAssociationShareability shared. ] ifFalse: [ ^ MocoOntoUmlAssociationShareability new. ]
				]
		]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformation >> engine: aMocoTransformationEngine [
	"Sets the corresponding transformation engine."
	
	engine := aMocoTransformationEngine
]

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationTransformation >> initialize: aMocoOntoUmlAssociation from: anOPUMLAssociation [
	"Sets properties of the Moco associations from the OpenPonk association."
	
	aMocoOntoUmlAssociation name: anOPUMLAssociation name;
		derived: anOPUMLAssociation isDerived;
		source: (self toMocoSide: anOPUMLAssociation memberEnds first);
		target: (self toMocoSide: anOPUMLAssociation memberEnds second).
		
	^ aMocoOntoUmlAssociation
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlAssociationTransformation >> toMocoSide: aProperty [
	"Transforms OpenPonk association side to a Moco association side."
	
	| side |
	side := MocoOntoUmlAssociationSide new.
	
	side name: aProperty name;
		element: (engine detectOutputElement: aProperty type);
		visibility: (MocoOpenPonkUmlAttributeTransformation toMocoVisibility: aProperty visibility);
		shareability: (self class toMocoShareability: aProperty aggregation);
		frozen: (aProperty isReadOnly).
		
	((aProperty lowerValue isNil) and: (aProperty upperValue isNil))
		ifTrue: [
			side multiplicity lower value: 1. side multiplicity upper value: 1
		]
		ifFalse: [
			side multiplicity lower: (MocoUmlMultiplicityBound value: (aProperty lowerValue value)).
			side multiplicity upper: (MocoUmlMultiplicityBound value: (aProperty upperValue value)).
		].
	
	^ side
]
