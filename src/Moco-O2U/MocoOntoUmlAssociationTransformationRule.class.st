"
Transforms OntoUML associations into UML.
"
Class {
	#name : #MocoOntoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlAssociation
]

{ #category : #transforming }
MocoOntoUmlAssociationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: (self class modelSelector)
		notGuarded: #MocoOntoUmlAssociationTransformationRule.
	
	associations := associations reject: [ :each | (engine selectOutputElements: each) isNotEmpty ].
	
	associations do: [ :each | self transformAssociation: each ]
]

{ #category : #'private - processing' }
MocoOntoUmlAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation [
	"Modifies the transformed UML association. Returns false if the association shoud be discarded."
]

{ #category : #accessing }
MocoOntoUmlAssociationTransformationRule >> priority [
	^ 43
]

{ #category : #'private - transforming' }
MocoOntoUmlAssociationTransformationRule >> transformAssociation: aMocoOntoUmlAssociation [
	"Transforms the given OntoUML association to a UML association."
	
	| uml |

	uml := MocoUmlAssociation new.
	uml name: (aMocoOntoUmlAssociation name);
		derived: (aMocoOntoUmlAssociation derived);
		source: ((self transformAssociationSide: (aMocoOntoUmlAssociation source)) ifNil: [ ^ self ]);
		target: ((self transformAssociationSide: (aMocoOntoUmlAssociation target)) ifNil: [ ^ self ]).
	
	((self modifyAssociation: uml fromOriginal: aMocoOntoUmlAssociation) = false)
		ifFalse: [
			engine addOutputElement: uml withSource: aMocoOntoUmlAssociation
		].
	
	engine input guard: aMocoOntoUmlAssociation with: #MocoOntoUmlAssociationTransformationRule
]

{ #category : #'private - transforming' }
MocoOntoUmlAssociationTransformationRule >> transformAssociationSide: aMocoOntoUmlAssociationSide [
	"Transforms the given OntoUML association side to UML."
	
	| uml |
	uml := MocoUmlAssociationSide new.
	
	uml element: ((engine detectOutputElement: (aMocoOntoUmlAssociationSide element)) ifNil: [ ^ nil ]);
		visibility: (aMocoOntoUmlAssociationSide visibility);
		multiplicity: (aMocoOntoUmlAssociationSide multiplicity);
		name: (aMocoOntoUmlAssociationSide name);
		frozen: (aMocoOntoUmlAssociationSide frozen);
		navigable: (aMocoOntoUmlAssociationSide navigable).
	
	^ uml
]
