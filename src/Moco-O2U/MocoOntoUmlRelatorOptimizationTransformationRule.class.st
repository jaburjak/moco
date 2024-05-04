"
Removes empty relator classes from the UML model.
"
Class {
	#name : #MocoOntoUmlRelatorOptimizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRule >> checkIfOptimizable: aMocoOntoUmlRelator [
	"Returns true if the relator has no attributes, no extra associations and does not participate in generalizations."
	
	| class associations |
	class := self findOutClassFor: aMocoOntoUmlRelator.
	
	class ifNil: [ ^ false ].
	
	class attributes
		ifNotEmpty: [ ^ false ]. "has attributes"
	
	associations := self findAssociationsFor: class.
	
	((associations size) ~= 2)
		ifTrue: [ ^ false ]. "unexpected number of associations"
	
	(associations anySatisfy: [ :each | ((each source frozen) and: [ (each source element) == class ]) or: [ (each target frozen) and: [ (each target element) == class ] ] ])
		ifTrue: [ ^ false ]. "unexpected immutable association side"
	
	(associations anySatisfy: [ :each | (each source aggregation type isNotNil) or: [ each target aggregation type isNotNil ] ])
		ifTrue: [ ^ false ]. "unexpected aggregation"
		
	(associations anySatisfy: [ :each | (each source element) == (each target element) ])
		ifTrue: [ ^ false ]. "relator references itself"
	
	((engine output selectElementsOfKind: MocoUmlGeneralization) anySatisfy: [ :each | ((each supertype) == class) or: [ (each subtype) == class ] ])
		ifTrue: [ ^ false ]. "participates in generalizations"
	
	^ true
]

{ #category : #transforming }
MocoOntoUmlRelatorOptimizationTransformationRule >> execute [
	| relators |
	relators := engine input
		selectElementsOfKind: MocoOntoUmlRelator
		notGuarded: #MocoOntoUmlRelatorOptimizationTransformationRule.
	
	relators do: [ :each |
		(self checkIfOptimizable: each) ifTrue: [
			| question |
			question := MocoChoiceBuilder new.
			
			question question: ('Relator “' , (each name) , '” has no properties and can be optimized out. How do you want to proceed?');
				addChoice: 'Keep as is' withId: #keep;
				addChoice: 'Remove from model' withId: #optimize.
			
			((engine askChoice: question) = #optimize) ifTrue: [ self optimizeRelator: each ].
			
			engine input guard: each with: #MocoOntoUmlRelatorOptimizationTransformationRule
		]
	]
]

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRule >> findAssociationsFor: aMocoUmlClass [
	"Returns associations that reference the given class."
	
	^ (engine output selectElementsOfKind: MocoUmlAssociation) select: [ :each | each anySideIncludes: aMocoUmlClass ]
]

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRule >> findOutClassFor: aMocoOntoUmlClass [
	"Returns UML class generated from the given OntoUML class."
	
	^ engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoUmlClass
]

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRule >> multiplyMultiplicities: aCollection [
	"Multiplies association multiplicities. Input [a..b]*[c..d] results in [a*c..b*d]."
	
	| parts |
	parts := OrderedCollection with: (aCollection collect: [ :each | each lower ]) with: (aCollection collect: [ :each | each upper ]).
	parts := parts collect: [ :each | each inject: [ 1 ] into: [ :r :e | r value ifNil: [ nil ] ifNotNil: [ e value ifNil: [ nil ] ifNotNil: [ (r value) * (e value) ] ] ] ].
	
	^ MocoUmlMultiplicity lower: (MocoUmlMultiplicityBound value: (parts first)) upper: (MocoUmlMultiplicityBound value: (parts second))
]

{ #category : #'private - transforming' }
MocoOntoUmlRelatorOptimizationTransformationRule >> optimizeRelator: aMocoOntoUmlRelator [
	"Removes the relator from the output model and directly connects the mediated classes."
	
	| class associations sourceClassSide sourceRelatorSide targetClassSide targetRelatorSide association sourceSide targetSide |
	class := self findOutClassFor: aMocoOntoUmlRelator.
	associations := self findAssociationsFor: class.
	
	((associations first source element) == class)
		ifTrue: [
			sourceClassSide := associations first target.
			sourceRelatorSide := associations first source
		]
		ifFalse: [
			sourceClassSide := associations first source.
			sourceRelatorSide := associations first target
		].
	
	((associations second source element) == class)
		ifTrue: [
			targetClassSide := associations second target.
			targetRelatorSide := associations second source
		]
		ifFalse: [
			targetClassSide := associations second source.
			targetRelatorSide := associations second target
		].
	
	association := MocoUmlAssociation new.
	association name: (MocoNamingUtils toFirstLowerCase: (aMocoOntoUmlRelator name));
		derived: (associations first derived and: [ associations second derived ]).
	
	sourceSide := sourceClassSide copy.
	sourceSide multiplicity: (self multiplyMultiplicities: (OrderedCollection with: (sourceClassSide multiplicity) with: (targetRelatorSide multiplicity)));
		frozen: ((sourceSide frozen) and: [ targetRelatorSide frozen ]).
	
	targetSide := targetClassSide copy.
	targetSide multiplicity: (self multiplyMultiplicities: (OrderedCollection with: (sourceRelatorSide multiplicity) with: (targetClassSide multiplicity)));
		frozen: ((targetSide frozen) and: [ sourceRelatorSide frozen ]).
	
	association source: sourceSide;
		target: targetSide.
	
	associations do: [ :each | engine removeOutputElement: each ].
	
	engine addOutputElement: association withSource: aMocoOntoUmlRelator;
		removeOutputElement: class
]

{ #category : #accessing }
MocoOntoUmlRelatorOptimizationTransformationRule >> priority [
	^ 9
]
