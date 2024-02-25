"
Transforms OpenPonk’s OntoUML association to a Moco OntoUML association.
"
Class {
	#name : #MocoOpenPonkOntoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformationRule >> executeOn: anEngine [
	| associations |

	associations := anEngine inModel elements select: [ :e | MocoOpenPonkUmlQuery isElement: (e innerElement) ofStereotype: nil ofClass: OPUMLAssociation ].
	associations := associations select: [ :e | e meta outElements isEmpty ].
	
	associations do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toMocoAssociation: element innerElement withEngine: anEngine).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformationRule >> priority [
	^ 50
]

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationTransformationRule >> toMocoAssociation: anAssociation withEngine: anEngine [
	| moco |
	moco := MocoOntoUmlAssociation new.
	
	moco name: anAssociation name;
		derived: anAssociation isDerived;
		source: (self toMocoSide: anAssociation memberEnds first withEngine: anEngine);
		target: (self toMocoSide: anAssociation memberEnds second withEngine: anEngine).
	
	^ moco
]

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationTransformationRule >> toMocoSide: aProperty withEngine: anEngine [
	| moco |
	moco := MocoOntoUmlAssociationSide new.
	
	moco name: aProperty name;
		element: (anEngine findOutElementsFor: aProperty type) first innerElement;
		visibility: (MocoOpenPonkOntoUmlVisibilityHelper toMocoVisibility: aProperty visibility).
		
	((aProperty lowerValue isNil) and: (aProperty upperValue isNil))
		ifTrue: [
			moco multiplicity lower value: 1. moco multiplicity upper value: 1
		]
		ifFalse: [
			moco multiplicity lower: (MocoUmlMultiplicityBound value: (aProperty lowerValue value)).
			moco multiplicity upper: (MocoUmlMultiplicityBound value: (aProperty upperValue value)).
		].
	
	^ moco
]
