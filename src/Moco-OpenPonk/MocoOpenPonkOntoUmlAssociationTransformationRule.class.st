"
Transforms OpenPonk’s OntoUML association to a Moco OntoUML association.
"
Class {
	#name : #MocoOpenPonkOntoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlAssociation
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlAssociationTransformationRule class >> stereotypeSelector [
	^ nil
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlAssociationTransformationRule >> createOutputElement [
	"Returns a new Moco association object."
	
	^ (self class modelClass) new
]

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationTransformationRule >> execute [
	| associations |
	associations := self selectInputElements.
	
	associations do: [ :each |
		| association |
		association := self transformAssociation: each.
		
		engine addOutputElement: association withSource: each.
		engine input guard: each with: #MocoOpenPonkOntoUmlAssociationTransformationRule
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformationRule >> priority [
	^ 51
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlAssociationTransformationRule >> selectInputElements [
	^ engine input
		selectElementsOfKind: OPUMLAssociation
		ofStereotype: (self class stereotypeSelector ifNil: [ nil ] ifNotNil: [ self class stereotypeSelector asString ])
		notGuarded: #MocoOpenPonkOntoUmlAssociationTransformationRule.
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlAssociationTransformationRule >> toMocoShareability: aSymbol [
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

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlAssociationTransformationRule >> toMocoSide: aProperty [
	"Transforms OpenPonk association side to a Moco association side."
	
	| side |
	side := MocoOntoUmlAssociationSide new.
	
	side name: aProperty name;
		element: (engine detectOutputElement: aProperty type);
		visibility: (MocoOpenPonkUmlAttributeTransformation toMocoVisibility: aProperty visibility);
		shareability: (self toMocoShareability: aProperty aggregation);
		frozen: (aProperty isReadOnly);
		navigable: (aProperty isNavigable);
		ordered: (aProperty isOrdered).
		
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

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlAssociationTransformationRule >> transformAssociation: anOPUMLAssociation [
	"Transforms the given association into a Moco OntoUML association."
	
	| association |
	association := self createOutputElement.
	
	association name: anOPUMLAssociation name;
		derived: anOPUMLAssociation isDerived;
		source: (self toMocoSide: anOPUMLAssociation memberEnds first);
		target: (self toMocoSide: anOPUMLAssociation memberEnds second).
	
	^ association
]
