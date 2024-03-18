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
	associations := engine inModel elements select: [ :each | (each isWrappingType: MocoUmlAssociation) and: [ each meta isNotProcessedBy: #MocoOpenPonkUmlAssociationTransformationRule ] ].
	
	associations do: [ :each |
		| association |
		association := self toOpenPonkAssociation: (each innerElement).
		association := MocoWrappedElement from: association.
		
		each meta outElements add: association.
		engine outModel elements add: association.
		
		each meta markProcessedBy: #MocoOpenPonkUmlAssociationTransformationRule
	].

	associations ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoOpenPonkUmlAssociationTransformationRule >> findOutClassFor: aMocoUmlClass [
	^ ((engine findOutElementsFor: aMocoUmlClass) select: [ :each | each isWrappingType: OPUMLClass ]) first innerElement
]

{ #category : #accessing }
MocoOpenPonkUmlAssociationTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlAssociationTransformationRule >> toOpenPonkAssociation: aMocoUmlAssociation [
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
	| op multiplicity |
	op := OPUMLProperty new.
	
	op name: (aMocoUmlAssociationSide name ifEmpty: [ nil ] ifNotEmpty: [ aMocoUmlAssociationSide name ]);
		isReadOnly: (aMocoUmlAssociationSide frozen);
		visibility: (aMocoUmlAssociationSide visibility visibility);
		aggregation: (aMocoUmlAssociationSide aggregation type).
		
	multiplicity := MocoOpenPonkOntoUmlAttributeHelper toOpenPonkMultiplicity: (aMocoUmlAssociationSide multiplicity).
	
	op lowerValue: (multiplicity first);
		upperValue: (multiplicity last).
		
	op type: (self findOutClassFor: (aMocoUmlAssociationSide element)).
		
	^ op
]
