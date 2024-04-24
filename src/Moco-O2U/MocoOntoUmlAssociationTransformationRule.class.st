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
	
	associations do: [ :each |
		| uml |
		uml := self toUmlAssociation: each.
		
		uml ifNotNil: [ engine addOutputElement: uml withSource: each ].
		
		engine input guard: each with: #MocoOntoUmlAssociationTransformationRule
	]
]

{ #category : #accessing }
MocoOntoUmlAssociationTransformationRule >> priority [
	^ 43
]

{ #category : #'private - transforming' }
MocoOntoUmlAssociationTransformationRule >> toUmlAssociation: aMocoOntoUmlAssociation [
	"Transforms the given OntoUML association to a UML association."
	
	| uml |

	uml := MocoUmlAssociation new.
	uml name: (aMocoOntoUmlAssociation name);
		derived: (aMocoOntoUmlAssociation derived);
		source: ((self toUmlAssociationSide: (aMocoOntoUmlAssociation source)) ifNil: [ ^ self ]);
		target: ((self toUmlAssociationSide: (aMocoOntoUmlAssociation target)) ifNil: [ ^ self ]).
	
	^ uml
]

{ #category : #'private - transforming' }
MocoOntoUmlAssociationTransformationRule >> toUmlAssociationSide: aMocoOntoUmlAssociationSide [
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
