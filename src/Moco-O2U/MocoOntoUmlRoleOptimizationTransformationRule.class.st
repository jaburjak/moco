"
Removes empty role classes from the UML model.
"
Class {
	#name : #MocoOntoUmlRoleOptimizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRoleOptimizationTransformationRule >> checkIfOptimizable: aMocoOntoUmlRole [
	"Returns true if the given role has no attributes, has no subtypes and does not participate in any associations except for mediation or material relationships."
	
	| associations |
	
	aMocoOntoUmlRole attributes ifNotEmpty: [ ^ false ]. "has attributes"
	
	((engine input selectElementsOfKind: MocoOntoUmlGeneralization) anySatisfy: [ :each | (each supertype) == aMocoOntoUmlRole ])
		ifTrue: [ ^ false ]. "has subtypes"
	
	associations := (engine input selectElementsOfKind: MocoOntoUmlAssociation) select: [ :each | each anySideIncludes: aMocoOntoUmlRole ].
	
	(associations reject: [ :each | (each isKindOf: MocoOntoUmlMediationAssociation) or: [ each isKindOf: MocoOntoUmlMaterialAssociation ] ])
		ifNotEmpty: [ ^ false ]. "participates in associations other than mediations and materials"
	
	(associations anySatisfy: [ :each | (each source shareability type isNotNil) or: [ each target shareability type isNotNil ] ])
		ifTrue: [ ^ false ]. "has unexpected shareability property"
	
	(associations anySatisfy: [ :each | (each source element) == (each target element) ])
		ifTrue: [ ^ false ]. "references itself"
	
	(((associations select: [ :each | each isKindOf: MocoOntoUmlMediationAssociation ]) size) > 1)
		ifTrue: [ ^ false ]. "participates in multiple mediation relationships"
	
	(((associations select: [ :each | each isKindOf: MocoOntoUmlMaterialAssociation ]) size) > 1)
		ifTrue: [ ^ false ]. "participates in multiple material relationships"
	
	(self findIdentityBearer: aMocoOntoUmlRole)
		ifNil: [ ^ false ]. "has no identity -- handle invalid OntoUML models"
	
	((((engine input selectElementsOfKind: MocoOntoUmlGeneralization) select: [ :each | (each subtype) == aMocoOntoUmlRole ]) size) > 1)
		ifTrue: [ ^ false ]. "has multiple supertypes"
	
	^ true
]

{ #category : #transforming }
MocoOntoUmlRoleOptimizationTransformationRule >> execute [
	| roles |
	roles := engine input
		selectElementsOfKind: MocoOntoUmlRole
		notGuarded: #MocoOntoUmlRoleOptimizationTransformationRule.
	
	roles do: [ :each |
		(self checkIfOptimizable: each) ifTrue: [
			| question |
			question := MocoChoiceBuilder new.
			
			question question: ('Role “' , (each name) , '” has no properties and can be optimized out. How do you want to proceed?');
				addChoice: 'Keep as is' withId: #keep;
				addChoice: 'Remove from model' withId: #optimize.
			
			((engine askChoice: question) = #optimize) ifTrue: [ self optimizeRole: each ].
			
			engine input guard: each with: #MocoOntoUmlRoleOptimizationTransformationRule
		]
	]
]

{ #category : #'private - processing' }
MocoOntoUmlRoleOptimizationTransformationRule >> findIdentityBearer: aMocoOntoUmlRole [
	"Returns the identity bearer of the given role."
	
	| generalizations |
	generalizations := (engine input selectElementsOfKind: MocoOntoUmlGeneralization) select: [ :each | (each subtype) == aMocoOntoUmlRole ].
	generalizations := generalizations reject: [ :each | { MocoOntoUmlRoleMixin. MocoOntoUmlMixin } anySatisfy: [ :e | each isKindOf: e ] ].
	
	((generalizations size) = 1) ifTrue: [ ^ engine detectOutputElement: (generalizations first supertype) ofKind: MocoUmlClass ].
	
	generalizations := generalizations select: [ :each | MocoOntoUmlIdentityUtils checkIfHasIdentity: (each supertype) inModel: (engine input elements) ].
	
	((generalizations size) = 1) ifTrue: [ ^ engine detectOutputElement: (generalizations first supertype) ofKind: MocoUmlClass ].
	
	^ nil
]

{ #category : #'private - transforming' }
MocoOntoUmlRoleOptimizationTransformationRule >> optimizeRole: aMocoOntoUmlRole [
	"Removes the given role class from the output model."
	
	| roleClass |
	roleClass := engine detectOutputElement: aMocoOntoUmlRole ofKind: MocoUmlClass.
	
	self rewireAssociations: aMocoOntoUmlRole;
		rewireGeneralizations: aMocoOntoUmlRole.
	
	engine removeOutputElement: roleClass
]

{ #category : #accessing }
MocoOntoUmlRoleOptimizationTransformationRule >> priority [
	^ 10
]

{ #category : #'private - processing' }
MocoOntoUmlRoleOptimizationTransformationRule >> rewireAssociations: aMocoOntoUmlRole [
	"Rewires associations of the given role to reference its identity bearer."
	
	| roleClass identityBearer associations |
	roleClass := engine detectOutputElement: aMocoOntoUmlRole ofKind: MocoUmlClass.
	identityBearer := self findIdentityBearer: aMocoOntoUmlRole.
	
	associations := engine output selectElementsOfKind: MocoUmlAssociation.
	
	(associations select: [ :each | ((each source element) == roleClass) and: [ ((each target element) == identityBearer) not ] ]) do: [ :each |
		each source element: identityBearer.
		each target multiplicity lower: (MocoUmlMultiplicityBound value: 0).
		each source name: (MocoNamingUtils toFirstLowerCase: (aMocoOntoUmlRole name))
	].
	
	(associations select: [ :each | ((each target element) == roleClass) and: [ ((each source element) == identityBearer) not ] ]) do: [ :each |
		each target element: identityBearer.
		each source multiplicity lower: (MocoUmlMultiplicityBound value: 0)
	].

	(associations select: [ :each | each anySideIncludes: roleClass ]) do: [ :each | engine removeOutputElement: each ]
]

{ #category : #'private - processing' }
MocoOntoUmlRoleOptimizationTransformationRule >> rewireGeneralizations: aMocoOntoUmlRole [
	"Rewires generalizations of the given role to reference its identity provider."
	
	| roleClass identityBearer generalizations |
	roleClass := engine detectOutputElement: aMocoOntoUmlRole ofKind: MocoUmlClass.
	identityBearer := self findIdentityBearer: aMocoOntoUmlRole.
	generalizations := engine output selectElementsOfKind: MocoUmlGeneralization.
	generalizations := generalizations select: [ :each | (each subtype) == roleClass ].
	
	generalizations do: [ :each |
		each subtype: identityBearer
	]
]
