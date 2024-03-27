"
Transforms a UML association from Moco’s model to OpenPonk’s model.
"
Class {
	#name : #MocoOpenPonkUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Uml'
}

{ #category : #transforming }
MocoOpenPonkUmlAssociationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: MocoUmlAssociation
		notGuarded: #MocoOpenPonkUmlAssociationTransformationRule.
	
	associations do: [ :each |
		| association |
		association := self toOpenPonkAssociation: each.
		
		engine addOutputElement: association withSource: each.
		engine input guard: each with: #MocoOpenPonkUmlAssociationTransformationRule
	]
]

{ #category : #'private - processing' }
MocoOpenPonkUmlAssociationTransformationRule >> findOutClassFor: aMocoUmlClass [
	"Returns an OpenPonk class that was generated from the given Moco element."
	
	^ engine detectOutputElement: aMocoUmlClass ofKind: OPUMLClass
]

{ #category : #accessing }
MocoOpenPonkUmlAssociationTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlAssociationTransformationRule >> toOpenPonkAssociation: aMocoUmlAssociation [
	"Creates an OpenPonk association from the given Moco element."
	
	| op |
	op := OPUMLAssociation new.
	
	op name: (aMocoUmlAssociation name ifEmpty: [ nil ] ifNotEmpty: [ aMocoUmlAssociation name ]);
		isDerived: (aMocoUmlAssociation derived).
	
	(op memberEnds) add: (self toOpenPonkEnd: (aMocoUmlAssociation source));
		add: (self toOpenPonkEnd: (aMocoUmlAssociation target)).
		
	^ op
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlAssociationTransformationRule >> toOpenPonkEnd: aMocoUmlAssociationSide [
	"Creates an OpenPonk association side from the given side of a Moco association."
	
	| op multiplicity |
	op := OPUMLProperty new.
	
	op name: (aMocoUmlAssociationSide name ifEmpty: [ nil ] ifNotEmpty: [ aMocoUmlAssociationSide name ]);
		isReadOnly: (aMocoUmlAssociationSide frozen);
		visibility: (aMocoUmlAssociationSide visibility visibility);
		aggregation: (aMocoUmlAssociationSide aggregation type).
		
	multiplicity := MocoOpenPonkUmlAttributeTransformation toOpenPonkMultiplicity: (aMocoUmlAssociationSide multiplicity).
	
	op lowerValue: (multiplicity first);
		upperValue: (multiplicity last).
		
	op type: (self findOutClassFor: (aMocoUmlAssociationSide element)).
		
	^ op
]
