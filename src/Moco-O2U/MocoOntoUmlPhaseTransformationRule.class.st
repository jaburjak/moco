"
Transforms OntoUML Phases into UML classes.
"
Class {
	#name : #MocoOntoUmlPhaseTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#instVars : [
		'modelElements'
	],
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlPhaseTransformationRule class >> modelSelector [
	^ MocoOntoUmlPhase
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> askMethodFor: aMocoOntoUmlGeneralizationSet [
	| question builder |
	question := 'A phase partition was found. Please select how to transform "' , aMocoOntoUmlGeneralizationSet members first supertype name , '" and its phases ' , (', ' join: (aMocoOntoUmlGeneralizationSet members collect: [ :e | '"' , e subtype name , '"' ])) , '.' .
	
	builder := MocoChoiceBuilder new.
	
	builder question: question;
		addChoice: 'Transform using exclusive phase associations' withId: #epa;
		addChoice: 'Transform by an abstract phase' withId: #ap.
	
	(self checkIfOptimizable: aMocoOntoUmlGeneralizationSet)
		ifTrue: [ builder addChoice: 'Transform to a phase attribute' withId: #attr ].
	
	^ engine askChoice: builder
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> checkIfOptimizable: aMocoOntoUmlGeneralizationSet [
	"Checks if none of the subtypes in the generalization sets contain any attributes, are part of any associations and are not supertypes of any other classes."
	
	aMocoOntoUmlGeneralizationSet ifNotDisjoint: [ ^ false ].
	aMocoOntoUmlGeneralizationSet ifNotCovering: [ ^ false ].
	
	aMocoOntoUmlGeneralizationSet members do: [ :each |
		each subtype attributes ifNotEmpty: [ ^ false ].
		
		((engine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlAssociation ])
			anySatisfy: [ :e | ((e innerElement source element) == (each subtype)) or: [ (e innerElement target element) == (each subtype) ]])
			ifTrue: [ ^ false ].
		
		((engine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralization ])
			anySatisfy: [ :e | (e innerElement supertype == (each subtype)) ])
				ifTrue: [ ^ false ]
	].
	
	^ true
]

{ #category : #transforming }
MocoOntoUmlPhaseTransformationRule >> execute [
	super execute.
	
	self transformPhases
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> findOutElementFor: anObject [
	^ (engine findOutElementsFor: anObject) first innerElement
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> generatePhasePartitionName: aMocoWrappedElement [
	aMocoWrappedElement innerElement name
		ifNotEmpty: [ ^ aMocoWrappedElement innerElement name ]
		ifEmpty: [
			| supertype count |
			supertype := aMocoWrappedElement innerElement members first supertype.
			
			count := (engine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlGeneralizationSet) and: [ ((each innerElement members first supertype) == supertype) and: [ each meta isProcessedBy: #MocoOntoUmlPhaseTransformationRule ] ] ]) size.
			
			count := count + 1.
			
			^ 'Phase' , ((count = 1) ifTrue: [ '' ] ifFalse: [ count asString ])
		]
]

{ #category : #'private - accessing' }
MocoOntoUmlPhaseTransformationRule >> modelElements [
	modelElements ifNil: [
		modelElements := engine inModel elements collect: [ :each | each innerElement ]
	].

	^ modelElements
]

{ #category : #accessing }
MocoOntoUmlPhaseTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformPhases [
	| sets |
	sets := engine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlGeneralizationSet) and: [ each meta isNotProcessedBy: #MocoOntoUmlPhaseTransformationRule ] ].
	sets := sets select: [ :each | (each innerElement members contains: [ :m | m subtype isKindOf: MocoOntoUmlPhase ]) and: [ MocoOntoUmlIdentityUtils checkIfHasIdentity: (each innerElement members first supertype) inModel: (self modelElements) ] ].
	
	sets do: [ :each |
		| method |
		method := self askMethodFor: (each innerElement).
		
		(method = #attr)
			ifTrue: [
				self transformUsingAttribute: each
			]
			ifFalse: [
				(method = #epa)
					ifTrue: [
						self transformUsingEpa: each
					]
					ifFalse: [
						self transformUsingAp: each
					]
			].
		
		each meta markProcessedBy: #MocoOntoUmlPhaseTransformationRule.
		engine outModel meta didChange: true.
	]
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingAp: aMocoWrappedElement [
	| partName abstract abstractOut source target association associationOut genSet genSetOut |
	partName := self generatePhasePartitionName: aMocoWrappedElement.

	abstract := MocoUmlClass new.
	abstract abstract: true;
		name: (aMocoWrappedElement innerElement members first supertype name) , partName.
	
	abstractOut := MocoWrappedElement from: abstract.
	engine outModel elements add: abstractOut.
	
	association := MocoUmlAssociation new.
	source := MocoUmlAssociationSide new.
	source element: (self findOutElementFor: (aMocoWrappedElement innerElement members first supertype));
		frozen: true;
		multiplicity: (MocoUmlMultiplicity value: 1);
		name: 'identityBearer'.
	target := MocoUmlAssociationSide new.
	target element: abstract;
		multiplicity: (MocoUmlMultiplicity value: 1);
		name: 'condition'.
	association source: source;
		target: target;
		name: (MocoNamingUtils toCamelCase: partName).
	
	associationOut := MocoWrappedElement from: association.
	engine outModel elements add: associationOut.
	
	genSet := MocoUmlGeneralizationSet new.
	genSet name: (aMocoWrappedElement innerElement name);
		disjoint: (aMocoWrappedElement innerElement disjoint);
		covering: (aMocoWrappedElement innerElement covering).
	
	aMocoWrappedElement innerElement members do: [ :each |
		| generalization outElement meta |
		
		generalization := MocoUmlGeneralization new.
		generalization supertype: abstract;
			subtype: (self findOutElementFor: (each subtype)).
		
		genSet members add: generalization.
			
		outElement := MocoWrappedElement from: generalization.
		
		meta := ((engine inModel elements select: [ :e | (e innerElement) == each ]) first) meta.
		
		meta markProcessedBy: #MocoOntoUmlPhaseTransformationRule.
		meta outElements add: outElement.
		engine outModel elements add: outElement.
	].

	genSetOut := MocoWrappedElement from: genSet.
	
	aMocoWrappedElement meta outElements add: genSetOut.
	
	engine outModel elements add: genSetOut.
	
	aMocoWrappedElement meta outElements add: abstractOut.
	aMocoWrappedElement meta outElements add: associationOut.
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingAttribute: aMocoWrappedElement [
	| bearer attribute ocl out |
	bearer := self findOutElementFor: (aMocoWrappedElement innerElement members first supertype).
	
	attribute := MocoUmlAttribute new.
	attribute name: (self generatePhasePartitionName: aMocoWrappedElement);
		type: (MocoOntoUmlType newFromName: 'String').
	
	(attribute multiplicity) lower: (MocoUmlMultiplicityBound value: 1);
		upper: (MocoUmlMultiplicityBound value: 1).
	
	bearer attributes add: attribute.
	
	ocl := MocoOclEnumerationConstraint new.
	ocl context: bearer;
		name: ('EN_' , attribute name , '_Condition' );
		attribute: attribute.
	ocl values addAll: (aMocoWrappedElement innerElement members collect: [ :each | each subtype name ]).
	
	out := OrderedCollection with: (MocoWrappedElement from: attribute) with: (MocoWrappedElement from: ocl).
	
	(engine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlGeneralization) and: [ aMocoWrappedElement innerElement members anySatisfy: [ :e | e == (each innerElement) ] ] ])
		do: [ :each |
			each meta outElements addAll: out.
			each meta markProcessedBy: #MocoOntoUmlPhaseTransformationRule
		].
	
	aMocoWrappedElement innerElement members do: [ :each |
		| phase |
		phase := engine findOutElementsFor: (each subtype).
		
		phase do: [ :p |
			engine outModel elements removeAllSuchThat: [ :e | e == p ]
		]
	].
	
	aMocoWrappedElement meta outElements addAll: out.
	engine outModel elements add: (out second)
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingEpa: aMocoWrappedElement [
	| context ocl outOcl |
	context := self findOutElementFor: (aMocoWrappedElement innerElement members first supertype).

	ocl := MocoOclExclusiveAssociationCondition new.
	ocl context: context;
		name: ('EX_' , (self generatePhasePartitionName: aMocoWrappedElement) , '_Condition').
	
	outOcl := MocoWrappedElement from: ocl.
	
	engine outModel elements add: outOcl.

	aMocoWrappedElement innerElement members do: [ :each |
		| source target association outElement generalization |
		
		source := MocoUmlAssociationSide new.
		source element: (self findOutElementFor: (each supertype));
			multiplicity: (MocoUmlMultiplicity value: 1);
			frozen: true;
			name: 'identityBearer'.
		
		target := MocoUmlAssociationSide new.	
		target element: (self findOutElementFor: (each subtype));
			multiplicity: (MocoUmlMultiplicity lower: 0 upper: 1);
			name: 'phase'.
		
		association := MocoUmlAssociation new.
		association source: source;
			target: target;
			name: (MocoNamingUtils toCamelCase: (each subtype name)).
			
		outElement := MocoWrappedElement from: association.
		
		ocl associations add: association.
		
		generalization := (engine inModel elements select: [ :e | (e innerElement) == each ]) first.
		
		generalization meta markProcessedBy: #MocoOntoUmlPhaseTransformationRule.
		generalization meta outElements add: outElement.
		engine outModel elements add: outElement.
	].

	
	aMocoWrappedElement meta outElements add: outOcl.
]
