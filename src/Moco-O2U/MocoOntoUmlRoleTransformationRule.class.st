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
MocoOntoUmlRoleTransformationRule >> execute [
	super execute.
	
	self transformRoleGeneralizations.
]

{ #category : #'private - processing' }
MocoOntoUmlRoleTransformationRule >> findOutElementFor: anObject [
	^ (engine findOutElementsFor: anObject) first innerElement
]

{ #category : #accessing }
MocoOntoUmlRoleTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoOntoUmlRoleTransformationRule >> transformRoleGeneralizations [
	| gens |
	gens := (engine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralization ]) select: [ :e | e meta isNotProcessedBy: #MocoOntoUmlRoleTransformationRule ].
	gens := gens select: [ :each | each innerElement subtype isKindOf: MocoOntoUmlRole ].
	
	gens do: [ :each |
		| association source target outElement |
		association := MocoUmlAssociation new.
		source := MocoUmlAssociationSide new.
		target := MocoUmlAssociationSide new.
		
		source element: (self findOutElementFor: (each innerElement supertype));
			multiplicity: (MocoUmlMultiplicity value: 1);
			frozen: true;
			name: 'identityBearer'.
			
		target element: (self findOutElementFor: (each innerElement subtype));
			multiplicity: (MocoUmlMultiplicity lower: 0 upper: 1);
			name: 'role'.
		
		association source: source;
			target: target;
			name: (MocoNamingUtils toCamelCase: (each innerElement subtype name)) , 'Role'.
		
		outElement := MocoWrappedElement from: association.
		
		each meta outElements add: outElement.
		each meta markProcessedBy: #MocoOntoUmlRoleTransformationRule.
		
		engine outModel elements add: outElement.
		engine outModel meta didChange: true.
	]
]
