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
MocoOntoUmlPhaseTransformationRule >> askMethod: anEngine for: aMocoOntoUmlGeneralizationSet [
	| question builder |
	question := 'A phase partition was found. Please select how to transform "' , aMocoOntoUmlGeneralizationSet members first supertype name , '" and its phases ' , (', ' join: (aMocoOntoUmlGeneralizationSet members collect: [ :e | '"' , e subtype name , '"' ])) , '.' .
	
	builder := MocoChoiceBuilder new.
	
	builder question: question;
		addChoice: 'Transform using exclusive phase associations' withId: #epa;
		addChoice: 'Transforms by an abstract phase' withId: #ap.
		
	^ anEngine askChoice: builder
]

{ #category : #transforming }
MocoOntoUmlPhaseTransformationRule >> executeOn: anEngine [
	super executeOn: anEngine.
	
	self transformPhases: anEngine.
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> findOutElementFor: anObject on: anEngine [
	^ (anEngine findOutElementsFor: anObject) first innerElement
]

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRule >> generatePhasePartitionName: aMocoWrappedElement on: anEngine [
	aMocoWrappedElement innerElement name
		ifNotEmpty: [ ^ aMocoWrappedElement innerElement name ]
		ifEmpty: [
			| supertype count |
			supertype := aMocoWrappedElement innerElement members first supertype.
			
			count := (anEngine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlGeneralizationSet) and: [ ((each innerElement members first supertype) == supertype) and: [ each meta isProcessedBy: #MocoOntoUmlPhaseTransformationRule ] ] ]) size.
			
			count := count + 1.
			
			^ 'Phase' , (count asString)
		]
]

{ #category : #accessing }
MocoOntoUmlPhaseTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformPhases: anEngine [
	| sets |
	sets := anEngine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlGeneralizationSet) and: [ each meta isNotProcessedBy: #MocoOntoUmlPhaseTransformationRule ] ].
	sets := sets select: [ :each | each innerElement members contains: [ :m | m subtype isKindOf: MocoOntoUmlPhase ] ].
	
	sets do: [ :each |
		| method |
		method := self askMethod: anEngine for: (each innerElement).
		
		(method = #epa)
			ifTrue: [
				self transformUsingEpa: each on: anEngine
			]
			ifFalse: [
				self transformUsingAp: each on: anEngine
			].
		
		each meta markProcessedBy: #MocoOntoUmlPhaseTransformationRule.
		anEngine outModel meta didChange: true.
	]
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingAp: aMocoWrappedElement on: anEngine [
	| partName abstract abstractOut source target association associationOut genSet genSetOut |
	partName := self generatePhasePartitionName: aMocoWrappedElement on: anEngine.

	abstract := MocoUmlClass new.
	abstract abstract: true;
		name: (aMocoWrappedElement innerElement members first supertype name) , partName.
	
	abstractOut := MocoWrappedElement from: abstract.
	anEngine outModel elements add: abstractOut.
	
	association := MocoUmlAssociation new.
	source := MocoUmlAssociationSide new.
	source element: (self findOutElementFor: (aMocoWrappedElement innerElement members first supertype) on: anEngine);
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
	anEngine outModel elements add: associationOut.
	
	genSet := MocoUmlGeneralizationSet new.
	genSet name: (aMocoWrappedElement innerElement name);
		disjoint: (aMocoWrappedElement innerElement disjoint);
		covering: (aMocoWrappedElement innerElement covering).
	
	aMocoWrappedElement innerElement members do: [ :each |
		| generalization outElement meta |
		
		generalization := MocoUmlGeneralization new.
		generalization supertype: abstract;
			subtype: (self findOutElementFor: (each subtype) on: anEngine).
		
		genSet members add: generalization.
			
		outElement := MocoWrappedElement from: generalization.
		
		meta := ((anEngine inModel elements select: [ :e | (e innerElement) == each ]) first) meta.
		
		meta markProcessedBy: #MocoOntoUmlPhaseTransformationRule.
		meta outElements add: outElement.
		anEngine outModel elements add: outElement.
	].

	genSetOut := MocoWrappedElement from: genSet.
	
	aMocoWrappedElement meta outElements add: genSetOut.
	
	anEngine outModel elements add: genSetOut.
	
	aMocoWrappedElement meta outElements add: abstractOut.
	aMocoWrappedElement meta outElements add: associationOut.
]

{ #category : #'private - transforming' }
MocoOntoUmlPhaseTransformationRule >> transformUsingEpa: aMocoWrappedElement on: anEngine [
	| ocl outOcl |

	ocl := MocoOclExclusivePhaseCondition new.
	ocl context: (self findOutElementFor: (aMocoWrappedElement innerElement members first supertype) on: anEngine);
		name: (self generatePhasePartitionName: aMocoWrappedElement on: anEngine).
	
	outOcl := MocoWrappedElement from: ocl.
	
	anEngine outModel elements add: outOcl.
	aMocoWrappedElement meta outElements add: outOcl.

	aMocoWrappedElement innerElement members do: [ :each |
		| source target association outElement generalization |
		
		source := MocoUmlAssociationSide new.
		source element: (self findOutElementFor: (each supertype) on: anEngine);
			multiplicity: (MocoUmlMultiplicity value: 1);
			frozen: true;
			name: 'identityBearer'.
		
		target := MocoUmlAssociationSide new.	
		target element: (self findOutElementFor: (each subtype) on: anEngine);
			multiplicity: (MocoUmlMultiplicity lower: 0 upper: 1);
			name: 'phase'.
		
		association := MocoUmlAssociation new.
		association source: source;
			target: target;
			name: (MocoNamingUtils toCamelCase: (each subtype name)).
			
		outElement := MocoWrappedElement from: association.
		
		ocl phaseAssociations add: association.
		
		generalization := (anEngine inModel elements select: [ :e | (e innerElement) == each ]) first.
		
		generalization meta markProcessedBy: #MocoOntoUmlPhaseTransformationRule.
		generalization meta outElements add: outElement.
		anEngine outModel elements add: outElement.
	]
]
