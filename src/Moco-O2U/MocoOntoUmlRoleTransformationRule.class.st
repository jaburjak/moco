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

{ #category : #transforming }
MocoOntoUmlRoleTransformationRule >> executeOn: anEngine [
	super executeOn: anEngine.
	
	self transformRoleGeneralizations: anEngine.
]

{ #category : #'private - processing' }
MocoOntoUmlRoleTransformationRule >> findOutElementFor: anObject on: anEngine [
	^ (anEngine findOutElementsFor: anObject) first innerElement
]

{ #category : #accessing }
MocoOntoUmlRoleTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoOntoUmlRoleTransformationRule >> transformRoleGeneralizations: anEngine [
	| gens |
	gens := (anEngine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralization ]) select: [ :e | e meta isNotProcessedBy: #MocoOntoUmlRoleTransformationRule ].
	gens := gens select: [ :each | each innerElement subtype isKindOf: MocoOntoUmlRole ].
	
	gens do: [ :each |
		| association source target outElement |
		association := MocoUmlAssociation new.
		source := MocoUmlAssociationSide new.
		target := MocoUmlAssociationSide new.
		
		source element: (self findOutElementFor: (each innerElement supertype) on: anEngine);
			multiplicity: (MocoUmlMultiplicity value: 1);
			frozen: true;
			name: 'identityBearer'.
			
		target element: (self findOutElementFor: (each innerElement subtype) on: anEngine);
			multiplicity: (MocoUmlMultiplicity lower: 0 upper: 1);
			name: 'role'.
		
		association source: source;
			target: target;
			name: 'Role ' , each innerElement subtype name , ' of ' , each innerElement supertype name.
		
		outElement := MocoWrappedElement from: association.
		
		each meta outElements add: outElement.
		each meta markProcessedBy: #MocoOntoUmlRoleTransformationRule.
		
		anEngine outModel elements add: outElement.
		anEngine outModel meta didChange: true.
	]
]
