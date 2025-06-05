"
Transforms associations between universals in an OntoUML model to an Alloy specification.
"
Class {
	#name : 'MocoO2ARelationTransformationRule',
	#superclass : 'MocoO2ATransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoO2ARelationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: MocoOntoUmlAssociation
		notGuarded: #MocoO2ARelationTransformationRule.
	
	associations do: [ :each | self transformRelation: each ].

	associations do: [ :each |  engine input guard: each with: #MocoO2ARelationTransformationRule ]
]

{ #category : 'private - processing' }
MocoO2ARelationTransformationRule >> findClassFieldFor: aMocoOntoUmlClass [
	^ engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField
]

{ #category : 'private - processing' }
MocoO2ARelationTransformationRule >> findEndFunctionFor: aMocoOntoUmlAssociationSide ofRelation: aMocoOntoUmlAssociation [
	| fns |
	fns := engine selectOutputElements: aMocoOntoUmlAssociation ofKind: MocoAlloyFunction.

	((aMocoOntoUmlAssociation source) == aMocoOntoUmlAssociationSide) ifTrue: [ ^ fns first ].

	((aMocoOntoUmlAssociation target) == aMocoOntoUmlAssociationSide) ifTrue: [ ^ fns second ].

	^ nil
]

{ #category : 'private - transforming' }
MocoO2ARelationTransformationRule >> generateAcyclicFactFor: aMocoOntoUmlAssociation [
	| fact field expr |
	fact := self findFact: 'acyclic'.

	field := engine detectOutputElement: aMocoOntoUmlAssociation ofKind: MocoAlloySignatureField.
	
	expr := 'all w: World | acyclic['.

	(self isOrdered: aMocoOntoUmlAssociation) ifTrue: [ expr := expr , 'select13[' ].
	expr := expr , 'w.' , (field name).
	(self isOrdered: aMocoOntoUmlAssociation) ifTrue: [ expr := expr , ']' ].
	expr := expr , ', w.' , ((self findClassFieldFor: (aMocoOntoUmlAssociation source element)) name) , ']'.

	self appendFact: fact with: expr.
	engine output setModified
]

{ #category : 'private - transforming' }
MocoO2ARelationTransformationRule >> generateImmutabilityFactOf: aMocoOntoUmlAssociation [
	| relation immSrc immTgt |
	relation := (engine detectOutputElement: aMocoOntoUmlAssociation ofKind: MocoAlloySignatureField) name.

	immSrc := aMocoOntoUmlAssociation source frozen.
	immTgt := aMocoOntoUmlAssociation target frozen.

	(aMocoOntoUmlAssociation isKindOf: MocoOntoUmlPartWholeAssociation) ifTrue: [
		aMocoOntoUmlAssociation inseparable ifTrue: [
			aMocoOntoUmlAssociation source shareability type ifNotNil: [ immSrc := true ].
			aMocoOntoUmlAssociation target shareability type ifNotNil: [ immTgt := true ]
		].

		aMocoOntoUmlAssociation essential ifTrue: [
			aMocoOntoUmlAssociation source shareability type ifNotNil: [ immTgt := true ].
			aMocoOntoUmlAssociation target shareability type ifNotNil: [ immSrc := true ]
		]
	].

	immSrc ifTrue: [
		self appendFact: (self immutabilityFact) with: ('immutable_source[', ((self findClassFieldFor: (aMocoOntoUmlAssociation source element)) name) , ', ' , relation , ']')
	].

	immTgt ifTrue: [
		self appendFact: (self immutabilityFact) with: ('immutable_target[', ((self findClassFieldFor: (aMocoOntoUmlAssociation target element)) name) , ', ' , relation , ']')
	]
]

{ #category : 'private - transforming' }
MocoO2ARelationTransformationRule >> generateMultiplicityFactFor: aMocoOntoUmlAssociationSide of: aMocoOntoUmlAssociation [
	| lower upper fact name conditions |
	lower := aMocoOntoUmlAssociationSide multiplicity lower.
	upper := aMocoOntoUmlAssociationSide multiplicity upper.

	(((lower isZero) or: [ lower isOne ]) and: [ ((upper isOne) or: [ upper isUnbounded ]) ])
		ifTrue: [ ^ self ].

	fact := self findFact: 'multiplicity'.
	name := (self findEndFunctionFor: aMocoOntoUmlAssociationSide ofRelation: aMocoOntoUmlAssociation) name.

	conditions := OrderedCollection new.

	((lower isMandatory) and: [ lower isNotZero ]) ifTrue: [
		conditions add: ('#' , name , '[x, w] >= ' , (lower value asString)) ].

	((upper isBounded) and: [ upper isNotOne ]) ifTrue: [
		conditions add: ('#' , name , '[x, w] <= ' , (upper value asString)) ].

	conditions ifEmpty: [ ^ self ].

	self appendFact: fact with: ('all w: World, x: w.' , ((self findClassFieldFor: (aMocoOntoUmlAssociationSide element)) name) , ' | (' , (' and ' join: conditions) , ')').

	engine output setModified
]

{ #category : 'private - processing' }
MocoO2ARelationTransformationRule >> generateMultiplicityFactOf: aMocoOntoUmlAssociation [
	self generateMultiplicityFactFor: (aMocoOntoUmlAssociation source) of: aMocoOntoUmlAssociation;
		generateMultiplicityFactFor: (aMocoOntoUmlAssociation target) of: aMocoOntoUmlAssociation
]

{ #category : 'private - transforming' }
MocoO2ARelationTransformationRule >> generateOrderingFactFor: aMocoOntoUmlAssociation withField: aMocoAlloySignatureField [
	| className |

	(self isOrdered: aMocoOntoUmlAssociation) ifFalse: [ ^ self ].

	className := (self findClassFieldFor: (aMocoOntoUmlAssociation source element)) name.

	self appendFact: (self orderingFact)
		with: ('all w:World, x: w.' , className , ' | isSeq[x.(w.' , (aMocoAlloySignatureField name) , ']').

	self appendFact: (self orderingFact)
		with: ('all w:World, x: w.' , className ,', y:w.' , className , ' | lone x.((w.' , (aMocoAlloySignatureField name) , ').y)')
]

{ #category : 'private - transforming' }
MocoO2ARelationTransformationRule >> generateSourceEndFnFor: aMocoOntoUmlAssociation withField: aMocoAlloySignatureField [
	| name fun |
	(aMocoOntoUmlAssociation source name)
		ifEmpty: [
			name := aMocoAlloySignatureField name , '_srcEnd'
		]
		ifNotEmpty: [
			name := aMocoAlloySignatureField name , '_' , aMocoOntoUmlAssociation source name , 'End'
		].

	fun := MocoAlloyFunction new
		name: (self toLowerAlloyName: name);
		output: ('set World.' , ((self findClassFieldFor: (aMocoOntoUmlAssociation source element)) name));
		yourself.

	(self isTernary: aMocoOntoUmlAssociation)
		ifTrue: [ fun body: ('(select13[w.' , (aMocoAlloySignatureField name) , ']).x') ]
		ifFalse: [ fun body: ('(w.' , (aMocoAlloySignatureField name) , ').x') ].

	(fun arguments)
		add: 'x' ofType: ('World.' , ((self findClassFieldFor: (aMocoOntoUmlAssociation target element)) name));
		add: 'w' ofType: 'World'.

	engine addOutputElement: fun withSource: aMocoOntoUmlAssociation.

	^ fun
]

{ #category : 'private - transforming' }
MocoO2ARelationTransformationRule >> generateTargetEndFnFor: aMocoOntoUmlAssociation withField: aMocoAlloySignatureField [
	| name fun |
	(aMocoOntoUmlAssociation target name)
		ifEmpty: [
			name := aMocoAlloySignatureField name , '_tgtEnd'
		]
		ifNotEmpty: [
			name := aMocoAlloySignatureField name , '_' , aMocoOntoUmlAssociation target name , 'End'
		].

	fun := MocoAlloyFunction new
		name: (self toLowerAlloyName: name);
		output: ('set World.' , ((self findClassFieldFor: (aMocoOntoUmlAssociation target element)) name));
		yourself.

	(self isTernary: aMocoOntoUmlAssociation)
		ifTrue: [ fun body: ('x.(select13[w.' , (aMocoAlloySignatureField name) , '])') ]
		ifFalse: [ fun body: ('x.(w.' , (aMocoAlloySignatureField name) , ')') ].

	(fun arguments)
		add: 'x' ofType: ('World.' , ((self findClassFieldFor: (aMocoOntoUmlAssociation source element)) name));
		add: 'w' ofType: 'World'.

	engine addOutputElement: fun withSource: aMocoOntoUmlAssociation.

	^ fun
]

{ #category : 'private - accessing' }
MocoO2ARelationTransformationRule >> immutabilityFact [
	^ self findFact: 'associationProperties'
]

{ #category : 'private - processing' }
MocoO2ARelationTransformationRule >> isOrdered: aMocoOntoUmlAssociation [
	^ (aMocoOntoUmlAssociation source ordered) or: [ aMocoOntoUmlAssociation target ordered ]
]

{ #category : 'private - processing' }
MocoO2ARelationTransformationRule >> isTernary: aMocoOntoUmlAssociation [
	| field |
	field := engine selectOutputElements: aMocoOntoUmlAssociation ofKind: MocoAlloySignatureField.

	field ifNotEmpty: [
		((((RxMatcher forString: '->') matchesIn: ((field first) signature)) size) > 1) ifTrue: [ ^ true ]
	].

	^ false
]

{ #category : 'private - accessing' }
MocoO2ARelationTransformationRule >> orderingFact [
	^ self findFact: 'ordering'
]

{ #category : 'accessing' }
MocoO2ARelationTransformationRule >> priority [
	^ 50
]

{ #category : 'private - processing' }
MocoO2ARelationTransformationRule >> transformCardinality: aMocoOntoUmlAssociationSide [
	| multiplicity |
	multiplicity := aMocoOntoUmlAssociationSide multiplicity.

	((multiplicity lower isMandatory) and: [ multiplicity upper isSingle ]) ifTrue: [ ^ #one ].

	multiplicity upper isSingle ifTrue: [ ^ #lone ].

	multiplicity lower isMandatory ifTrue: [ ^ #some ].

	^ #set
]

{ #category : 'private - transforming' }
MocoO2ARelationTransformationRule >> transformRelation: aMocoOntoUmlAssociation [
	| sig field |
	sig := ((self findClassFieldFor: (aMocoOntoUmlAssociation source element)) name) , ' ' , (self transformCardinality: (aMocoOntoUmlAssociation source)).
	sig := sig , ' -> '.
	(self isOrdered: aMocoOntoUmlAssociation) ifTrue: [ sig := sig , 'set Int set -> ' ].
	sig := sig , (self transformCardinality: (aMocoOntoUmlAssociation target)) , ' ' , ((self findClassFieldFor: (aMocoOntoUmlAssociation target element)) name).

	field := MocoAlloySignatureField new
		name: (self toLowerAlloyName: (aMocoOntoUmlAssociation name) ifEmpty: 'relation');
		multiplicity: #set;
		signature: sig;
		yourself.

	(self worldSig) fields add: field.

	engine atInput: aMocoOntoUmlAssociation putOutputElement: field.
	
	self generateSourceEndFnFor: aMocoOntoUmlAssociation withField: field;
		generateTargetEndFnFor: aMocoOntoUmlAssociation withField: field;
		generateOrderingFactFor: aMocoOntoUmlAssociation withField: field;
		generateMultiplicityFactOf: aMocoOntoUmlAssociation;
		generateImmutabilityFactOf: aMocoOntoUmlAssociation.

	engine output setModified
]
