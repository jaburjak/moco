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
	| class associations |
	class := self findOutClassFor: aMocoOntoUmlRelator.
	
	class ifNil: [ ^ false ].
	
	class := class innerElement.
	
	class attributes ifNotEmpty: [ ^ false ].
	
	associations := self findAssociationsFor: class.
	
	((associations size) ~= 2) ifTrue: [ ^ false ].
	
	(associations anySatisfy: [ :each | ((each innerElement source frozen) and: [ (each innerElement source element) == class ]) or: [ (each innerElement target frozen) and: [ (each innerElement target element) == class ] ] ])
		ifTrue: [ ^ false ].
	
	(associations anySatisfy: [ :each | (each innerElement source aggregation type isNotNil) or: [ each innerElement target aggregation type isNotNil ] ]) ifTrue: [ ^ false ].
		
	(associations anySatisfy: [ :each | (each innerElement source element) == (each innerElement target element) ]) ifTrue: [ ^ false ].
	
	(engine outModel elements anySatisfy: [ :each | (each isWrappingType: MocoUmlGeneralization) and: [ ((each innerElement supertype) == class) or: [ (each innerElement subtype) == class ] ] ])
		ifTrue: [ ^ false ].
	
	^ true
]

{ #category : #transforming }
MocoOntoUmlRelatorOptimizationTransformationRule >> execute [
	| relators |
	relators := engine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlRelator) and: [ each meta isNotProcessedBy: #MocoOntoUmlRelatorOptimizationTransformationRule ] ].
	
	relators do: [ :each |
		(self checkIfOptimizable: (each innerElement)) ifTrue: [
			| question |
			question := MocoChoiceBuilder new.
	
			question question: ('Relator "' , (each innerElement name) , '" has no properties and can be optimized out. How do you want to proceed?');
				addChoice: 'Keep as is' withId: #keep;
				addChoice: 'Remove from model' withId: #optimize.
				
			((engine askChoice: question) = #optimize) ifTrue: [
				self optimizeRelator: each.
				
				engine outModel meta didChange: true
			]
		].
	
		each meta markProcessedBy: #MocoOntoUmlRelatorOptimizationTransformationRule
	]
]

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRule >> findAssociationsFor: aMocoUmlClass [
	^ engine outModel elements select: [ :each | (each isWrappingType: MocoUmlAssociation) and: [ ((each innerElement source element) == aMocoUmlClass) or: [ (each innerElement target element) == aMocoUmlClass ] ] ]
]

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRule >> findOutClassFor: aMocoOntoUmlClass [
	^ (engine findOutElementsFor: aMocoOntoUmlClass) detect: [ :each | each isWrappingType: MocoUmlClass ] ifNone: [ nil ]
]

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRule >> multiplyMultiplicities: aCollection [
	| parts |
	parts := OrderedCollection with: (aCollection collect: [ :each | each lower ]) with: (aCollection collect: [ :each | each upper ]).
	parts := parts collect: [ :each | each inject: [ 1 ] into: [ :r :e | r value ifNil: [ nil ] ifNotNil: [ e value ifNil: [ nil ] ifNotNil: [ (r value) * (e value) ] ] ] ].
	
	^ MocoUmlMultiplicity lower: (MocoUmlMultiplicityBound value: (parts first)) upper: (MocoUmlMultiplicityBound value: (parts second))
]

{ #category : #'private - transforming' }
MocoOntoUmlRelatorOptimizationTransformationRule >> optimizeRelator: aMocoWrappedElement [
	| class associations sourceClassSide sourceRelatorSide targetClassSide targetRelatorSide association sourceSide targetSide |
	class := (self findOutClassFor: (aMocoWrappedElement innerElement)) innerElement.
	associations := self findAssociationsFor: class.
	
	((associations first innerElement source element) == class)
		ifTrue: [
			sourceClassSide := associations first innerElement target.
			sourceRelatorSide := associations first innerElement source
		]
		ifFalse: [
			sourceClassSide := associations first innerElement source.
			sourceRelatorSide := associations first innerElement target
		].
	
	((associations second innerElement source element) == class)
		ifTrue: [
			targetClassSide := associations second innerElement target.
			targetRelatorSide := associations second innerElement source
		]
		ifFalse: [
			targetClassSide := associations second innerElement source.
			targetRelatorSide := associations second innerElement target
		].
	
	association := MocoUmlAssociation new.
	association name: (MocoNamingUtils toFirstLowerCase: (aMocoWrappedElement innerElement name));
		derived: (associations first innerElement derived and: (associations second innerElement derived)).
	
	sourceSide := sourceClassSide copy.
	sourceSide multiplicity: (self multiplyMultiplicities: (OrderedCollection with: (sourceClassSide multiplicity) with: (targetRelatorSide multiplicity))).
	
	targetSide := targetClassSide copy.
	targetSide multiplicity: (self multiplyMultiplicities: (OrderedCollection with: (sourceRelatorSide multiplicity) with: (targetClassSide multiplicity))).
	
	association source: sourceSide;
		target: targetSide.
	
	associations do: [ :each |
		engine outModel elements removeAllSuchThat: [ :e | e == each ].
		aMocoWrappedElement meta outElements removeAllSuchThat: [ :e | e == each ].
	].
	
	association := MocoWrappedElement from: association.
	
	engine outModel elements add: association.
	aMocoWrappedElement meta outElements add: association.
	
	engine outModel elements removeAllSuchThat: [ :each | (each innerElement) == class ].
	aMocoWrappedElement meta outElements removeAllSuchThat: [ :each | (each innerElement) == class ]
]

{ #category : #accessing }
MocoOntoUmlRelatorOptimizationTransformationRule >> priority [
	^ 9
]
