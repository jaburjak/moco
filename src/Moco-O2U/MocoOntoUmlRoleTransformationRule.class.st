"
Transforms OntoUML Roles into UML classes.
"
Class {
	#name : #MocoOntoUmlRoleTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlRoleTransformationRule class >> modelSelector [
	^ MocoOntoUmlRole
]

{ #category : #'private - testing' }
MocoOntoUmlRoleTransformationRule >> checkIfRoleGeneralization: aMocoOntoUmlGeneralization [
	"Returns true if the given generalization is a role generalization."
	
	^ (aMocoOntoUmlGeneralization subtype isKindOf: MocoOntoUmlRole) and: [ MocoOntoUmlIdentityUtils checkIfHasIdentity: (aMocoOntoUmlGeneralization supertype) inModel: (engine input elements) ]
]

{ #category : #transforming }
MocoOntoUmlRoleTransformationRule >> execute [
	super execute.
	
	self transformRoleGeneralizations
]

{ #category : #accessing }
MocoOntoUmlRoleTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoOntoUmlRoleTransformationRule >> transformRoleGeneralization: aMocoOntoUmlGeneralization [
	"Transform the given role generalization to an association."
	
	| association source target generalization |
	association := MocoUmlAssociation new.
	source := MocoUmlAssociationSide new.
	target := MocoUmlAssociationSide new.
	
	source element: ((engine detectOutputElement: (aMocoOntoUmlGeneralization supertype)) ifNil: [ ^ self ]);
		multiplicity: (MocoUmlMultiplicity value: 1);
		frozen: true;
		name: 'identityBearer'.
		
	target element: (engine detectOutputElement: (aMocoOntoUmlGeneralization subtype));
		multiplicity: (MocoUmlMultiplicity lower: 0 upper: 1);
		name: 'role'.
	
	association source: source;
		target: target;
		name: (MocoNamingUtils toCamelCase: (aMocoOntoUmlGeneralization subtype name)) , 'Role'.
	
	generalization := engine detectOutputElement: aMocoOntoUmlGeneralization ofKind: MocoUmlGeneralization.
	generalization ifNotNil: [ engine removeOutputElement: generalization ].
	
	engine addOutputElement: association withSource: aMocoOntoUmlGeneralization.
	engine input guard: aMocoOntoUmlGeneralization with: #MocoOntoUmlRoleTransformationRule
]

{ #category : #'private - transforming' }
MocoOntoUmlRoleTransformationRule >> transformRoleGeneralizations [
	"Transforms role generalizations into associations."
	
	| generalizations |
	generalizations := engine input
		selectElementsOfKind: MocoOntoUmlGeneralization
		notGuarded: #MocoOntoUmlRoleTransformationRule.
	
	generalizations := generalizations select: [ :each | self checkIfRoleGeneralization: each ].
	
	generalizations do: [ :each | self transformRoleGeneralization: each ]
]
