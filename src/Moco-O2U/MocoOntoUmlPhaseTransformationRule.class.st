"
Transforms OntoUML Phases into UML classes.
"
Class {
	#name : #MocoOntoUmlPhaseTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlPhaseTransformationRule class >> modelSelector [
	^ MocoOntoUmlPhase
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> askMethodFor: aMocoOntoUmlGeneralizationSet [
	"Determines what transformation method should be used for the given phase partition."
	
	| question builder |
	question := 'A phase partition was found. Please select how to transform “' , aMocoOntoUmlGeneralizationSet members first supertype name , '” and its phases ' , (', ' join: (aMocoOntoUmlGeneralizationSet members collect: [ :e | '“' , e subtype name , '”' ])) , '.' .
	
	builder := MocoChoiceBuilder new.
	
	builder question: question.
	
	((aMocoOntoUmlGeneralizationSet disjoint) and: [ aMocoOntoUmlGeneralizationSet covering ])
		ifTrue: [ builder addChoice: 'Transform using exclusive phase associations' withId: #epa. ].
	
	builder addChoice: 'Transform by an abstract phase' withId: #ap.
	
	(self checkIfOptimizable: aMocoOntoUmlGeneralizationSet)
		ifTrue: [ builder addChoice: 'Transform to a phase attribute' withId: #attr ].
	
	((builder choices size) = 1)
		ifTrue: [ ^ builder choices first id ].
	
	^ engine askChoice: builder
]

{ #category : #'private - testing' }
MocoOntoUmlPhaseTransformationRule >> checkIfOptimizable: aMocoOntoUmlGeneralizationSet [
	"Checks if none of the subtypes in the generalization sets contain any attributes, are part of any associations and are not supertypes of any other classes."
	
	aMocoOntoUmlGeneralizationSet members do: [ :each |
		each subtype attributes ifNotEmpty: [ ^ false ].
		
		((engine input selectElementsOfKind: MocoOntoUmlAssociation)
			anySatisfy: [ :e | e anySideIncludes: (each subtype) ])
				ifTrue: [ ^ false ].
		
		((engine input selectElementsOfKind: MocoOntoUmlGeneralization)
			anySatisfy: [ :e | ((e == each) not) and: [ ((e supertype) == (each subtype)) or: [ (e subtype) == (each subtype) ] ] ])
				ifTrue: [ ^ false ]
	].
	
	^ true
]

{ #category : #'private - testing' }
MocoOntoUmlPhaseTransformationRule >> checkIfPhaseGeneralizationSet: aMocoOntoUmlGeneralizationSet [
	"Returns true if the given generalization set is a phase partition."
	
	^ (aMocoOntoUmlGeneralizationSet members anySatisfy: [ :each | each subtype isKindOf: MocoOntoUmlPhase ])
		and: [ MocoOntoUmlIdentityUtils checkIfHasIdentity: (aMocoOntoUmlGeneralizationSet members first supertype) inModel: (engine input elements) ]
]

{ #category : #transforming }
MocoOntoUmlPhaseTransformationRule >> execute [
	super execute.
	
	self transformPhases
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> generatePhasePartitionName: aMocoOntoUmlGeneralizationSet [
	"Returns a unique phase partition name."
	
	aMocoOntoUmlGeneralizationSet name
		ifNotEmpty: [ ^ aMocoOntoUmlGeneralizationSet name ]
		ifEmpty: [
			| supertype count |
			supertype := aMocoOntoUmlGeneralizationSet members first supertype.
			
			count := ((engine input selectElementsOfKind: MocoOntoUmlGeneralizationSet)
				select: [ :each | ((each members first supertype) == supertype) and: [ engine input check: each isGuarded: #MocoOntoUmlPhaseTransformationRule ] ]) size.
			
			count := count + 1.
			
			^ 'Phase' , ((count = 1) ifTrue: [ '' ] ifFalse: [ count asString ])
		]
]

{ #category : #accessing }
MocoOntoUmlPhaseTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformPhasePartition: aMocoOntoUmlGeneralizationSet [
	"Transforms the given phase partition to UML."
	
	| generalizationSet method |
	
	(aMocoOntoUmlGeneralizationSet members anySatisfy: [ :each | ((engine detectOutputElement: (each supertype)) isNil) or: [ (engine detectOutputElement: (each subtype)) isNil ] ])
		ifTrue: [ ^ self ].
	
	aMocoOntoUmlGeneralizationSet members do: [ :each |
		| generalization |
		generalization := engine detectOutputElement: each ofKind: MocoUmlGeneralization.
		generalization ifNotNil: [ engine removeOutputElement: generalization ]
	].

	generalizationSet := engine detectOutputElement: aMocoOntoUmlGeneralizationSet ofKind: MocoUmlGeneralizationSet.
	generalizationSet ifNotNil: [ engine removeOutputElement: generalizationSet ].
	
	method := self askMethodFor: aMocoOntoUmlGeneralizationSet.
	
	(method = #attr)
		ifTrue: [ self transformUsingAttribute: aMocoOntoUmlGeneralizationSet ]
		ifFalse: [
			(method = #epa)
				ifTrue: [ self transformUsingEpa: aMocoOntoUmlGeneralizationSet ]
				ifFalse: [ self transformUsingAp: aMocoOntoUmlGeneralizationSet ]
		].
	
	engine input guard: aMocoOntoUmlGeneralizationSet with: #MocoOntoUmlPhaseTransformationRule
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformPhases [
	"Transforms phase partitions to UML."
	
	| generalizationSets |
	generalizationSets := engine input
		selectElementsOfKind: MocoOntoUmlGeneralizationSet
		notGuarded: #MocoOntoUmlPhaseTransformationRule.
	
	generalizationSets := generalizationSets select: [ :each | self checkIfPhaseGeneralizationSet: each  ].
	
	generalizationSets do: [ :each | self transformPhasePartition: each ]
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingAp: aMocoOntoUmlGeneralizationSet [
	"Transforms the given phase partition via an abstract phase."
	
	| partName abstract source target association genSet |
	partName := self generatePhasePartitionName: aMocoOntoUmlGeneralizationSet.

	abstract := MocoUmlClass new.
	abstract abstract: true;
		name: (aMocoOntoUmlGeneralizationSet members first supertype name) , partName.
	
	association := MocoUmlAssociation new.
	
	target := MocoUmlAssociationSide new.
	target element: (engine detectOutputElement: (aMocoOntoUmlGeneralizationSet members first supertype));
		frozen: true;
		multiplicity: (MocoUmlMultiplicity value: 1);
		name: 'identityBearer'.
	
	source := MocoUmlAssociationSide new.
	source element: abstract;
		multiplicity: (MocoUmlMultiplicity value: 1);
		name: 'condition'.
	
	association source: source;
		target: target;
		name: (MocoNamingUtils toCamelCase: partName).
	
	genSet := MocoUmlGeneralizationSet new.
	genSet name: (aMocoOntoUmlGeneralizationSet name);
		disjoint: (aMocoOntoUmlGeneralizationSet disjoint);
		covering: (aMocoOntoUmlGeneralizationSet covering).
	
	aMocoOntoUmlGeneralizationSet members do: [ :each |
		| generalization |
		
		generalization := MocoUmlGeneralization new.
		generalization supertype: abstract;
			subtype: (engine detectOutputElement: (each subtype)).
		
		genSet members add: generalization.
		
		engine addOutputElement: generalization withSource: each.
		engine input guard: each with: #MocoOntoUmlPhaseTransformationRule
	].
	
	engine addOutputElement: genSet withSource: aMocoOntoUmlGeneralizationSet;
		addOutputElement: abstract withSource: aMocoOntoUmlGeneralizationSet;
		addOutputElement: association withSource: aMocoOntoUmlGeneralizationSet.
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingAttribute: aMocoOntoUmlGeneralizationSet [
	"Transforms the given phase partition to UML using a phase attribute."
	
	| bearer attribute ocl |
	bearer := engine detectOutputElement: (aMocoOntoUmlGeneralizationSet members first supertype).
	
	attribute := MocoUmlAttribute new.
	attribute name: (MocoNamingUtils toFirstLowerCase: (self generatePhasePartitionName: aMocoOntoUmlGeneralizationSet));
		type: (MocoUmlType newFromName: 'String').
	
	(attribute multiplicity) lower: (MocoUmlMultiplicityBound value: 1);
		upper: (MocoUmlMultiplicityBound value: 1).
	
	bearer attributes add: attribute.
	
	ocl := MocoOclEnumerationConstraint new.
	ocl context: bearer;
		name: ('EN_' , (bearer name) , '_' , (MocoNamingUtils toFirstUpperCase: (attribute name)) , '_Condition' );
		attribute: attribute.
	ocl values addAll: (((aMocoOntoUmlGeneralizationSet subtypeCombinations) collect: [ :each | '' join: (each collect: [ :e | e name ]) ])).
	
	((engine input selectElementsOfKind: MocoOntoUmlGeneralization) select: [ :each | aMocoOntoUmlGeneralizationSet members anySatisfy: [ :e | e == each ] ])
		do: [ :each |
			(engine input) at: each putOutputElement: attribute;
				at: each putOutputElement: ocl;
				guard: each with: #MocoOntoUmlPhaseTransformationRule
		].
	
	aMocoOntoUmlGeneralizationSet members do: [ :each | engine removeOutputElement: (engine detectOutputElement: (each subtype)) ].
	
	engine addOutputElement: ocl withSource: aMocoOntoUmlGeneralizationSet.
	engine input at: aMocoOntoUmlGeneralizationSet putOutputElement: attribute
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingEpa: aMocoOntoUmlGeneralizationSet [
	"Transforms the given phase partition to UML using exclusive phase associations."
	
	| context ocl associations |
	context := engine detectOutputElement: (aMocoOntoUmlGeneralizationSet members first supertype).

	ocl := MocoOclExclusiveAssociationCondition new.
	ocl context: context;
		name: ('EX_' , (context name) , '_' , (self generatePhasePartitionName: aMocoOntoUmlGeneralizationSet) , '_Condition').
	
	associations := OrderedCollection new.

	aMocoOntoUmlGeneralizationSet members do: [ :each |
		| source target association |
		
		source := MocoUmlAssociationSide new.
		source element: (engine detectOutputElement: (each supertype));
			multiplicity: (MocoUmlMultiplicity value: 1);
			frozen: true;
			name: 'identityBearer'.
		
		target := MocoUmlAssociationSide new.	
		target element: (engine detectOutputElement: (each subtype));
			multiplicity: (MocoUmlMultiplicity lower: 0 upper: 1);
			name: 'phase'.
		
		association := MocoUmlAssociation new.
		association source: source;
			target: target;
			name: (MocoNamingUtils toCamelCase: (each subtype name)).
		
		associations add: association.
		
		engine addOutputElement: association withSource: each.
		engine input guard: each with: #MocoOntoUmlPhaseTransformationRule
	].

	associations sort: [ :a :b | (a name) < (b name) ].
	
	(aMocoOntoUmlGeneralizationSet disjoint)
		ifTrue: [ associations := associations collect: [ :each | OrderedCollection with: each ] ]
		ifFalse: [ associations := associations combinations ].

	ocl associations addAll: associations.

	engine addOutputElement: ocl withSource: aMocoOntoUmlGeneralizationSet
]
