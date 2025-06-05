"
Transforms OntoUML classes to an Alloy specification.
"
Class {
	#name : 'MocoO2AClassTransformationRule',
	#superclass : 'MocoO2ATransformationRule',
	#instVars : [
		'natureCache'
	],
	#classVars : [
		'antiRigidTypes',
		'moments',
		'rigidTypes',
		'substantials'
	],
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoO2AClassTransformationRule class >> antiRigidTypes [
	antiRigidTypes ifNotNil: [ ^ antiRigidTypes ].

	antiRigidTypes := { MocoOntoUmlRole. MocoOntoUmlPhase. MocoOntoUmlRoleMixin. MocoOntoUmlPhaseMixin }.

	^ antiRigidTypes
]

{ #category : 'private - accessing' }
MocoO2AClassTransformationRule class >> moments [
	moments ifNotNil: [ ^ moments ].
	
	moments := { MocoOntoUmlRelator. MocoOntoUmlQuality. MocoOntoUmlMode }.

	^ moments
]

{ #category : 'private - accessing' }
MocoO2AClassTransformationRule class >> rigidTypes [
	rigidTypes ifNotNil: [ ^ rigidTypes ].

	rigidTypes := { MocoOntoUmlKind. MocoOntoUmlSubKind. MocoOntoUmlCollective. MocoOntoUmlQuantity. MocoOntoUmlRelator. MocoOntoUmlQuality. MocoOntoUmlMode. MocoOntoUmlCategory }.

	^ rigidTypes
]

{ #category : 'private - accessing' }
MocoO2AClassTransformationRule class >> substantials [
	substantials ifNotNil: [ ^ substantials ].
	
	substantials := { MocoOntoUmlKind. MocoOntoUmlCollective. MocoOntoUmlQuantity }.

	^ substantials
]

{ #category : 'private - accessing' }
MocoO2AClassTransformationRule >> abstractFact [
	^ self findFact: 'abstractClass'
]

{ #category : 'private - accessing' }
MocoO2AClassTransformationRule >> antiRigidFact [
	^ self findFact: 'antiRigid'
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> determineIntrinsicNatureOf: aMocoOntoUmlClass [
	(self is: aMocoOntoUmlClass aKindOf: (self class substantials)) ifTrue: [ ^ #Object ].
	(self is: aMocoOntoUmlClass aKindOf: (self class moments)) ifTrue: [ ^ #Aspect ].
	^ #Endurant
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> determineNatureOf: aMocoOntoUmlClass [
	| nature |

	natureCache do: [ :e | (e first == aMocoOntoUmlClass) ifTrue: [ ^ e second ] ].

	nature := self determineNatureOf: aMocoOntoUmlClass ignore: (OrderedCollection new).

	natureCache add: (OrderedCollection new add: aMocoOntoUmlClass; add: nature; yourself).

	^ nature
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> determineNatureOf: aMocoOntoUmlClass ignore: aCollection [
	| nature coll ignore |
	nature := self determineIntrinsicNatureOf: aMocoOntoUmlClass.
	(nature = #Endurant)
		ifTrue: [ nature := nil ]
		ifFalse: [ ^ nature ].

	coll := OrderedCollection new.
	coll addAll: ((engine input elements select: [ :e | (e isKindOf: MocoOntoUmlGeneralization) and: [ e supertype == aMocoOntoUmlClass ] ]) collect: [ :e | e subtype ]);
		addAll: ((engine input elements select: [ :e | (e isKindOf: MocoOntoUmlGeneralization) and: [ e subtype == aMocoOntoUmlClass ] ]) collect: [ :e | e supertype ]).

	coll removeAllSuchThat: [ :e | aCollection anySatisfy: [ :f | e == f ] ].
	
	ignore := OrderedCollection new.
	ignore addAll: aCollection;
		add: aMocoOntoUmlClass.

	coll do: [ :each |
		| n |
		n := self determineNatureOf: each ignore: ignore.
		(n = #Endurant) ifFalse: [
			nature
				ifNil: [ nature := n ]
				ifNotNil: [ (nature = n) ifFalse: [ nature := #Endurant ] ]
		]
	].

	nature ifNil: [ nature := #Endurant ].

	^ nature
]

{ #category : 'transforming' }
MocoO2AClassTransformationRule >> execute [
	| classes |
	natureCache := OrderedCollection new.

	classes := engine input
		selectElementsOfKind: MocoOntoUmlClass
		notGuarded: #MocoO2AClassTransformationRule.
	
	classes do: [ :each | self transformClass: each ].

	self generateAbstractFacts: classes;
		generateRigidityFacts: classes;
		generateExistenceConstraint: classes;
		generateIdentityConstraint: classes.

	classes do: [ :each |  engine input guard: each with: #MocoO2AClassTransformationRule ].

	natureCache := OrderedCollection new. "do not leak memory with references to model objects"
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> findAlloyNameOf: aMocoOntoUmlClass [
	^ (engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField) name
]

{ #category : 'private - transforming' }
MocoO2AClassTransformationRule >> generateAbstractFactFor: aMocoOntoUmlClass withField: aMocoAlloySignatureField [
	| subtypes |

	(aMocoOntoUmlClass abstract) ifFalse: [ ^ self ].

	subtypes := (engine input elements select: [ :e | (e isKindOf: MocoOntoUmlGeneralization) and: [ e supertype == aMocoOntoUmlClass ] ])
		collect: [ :e | 'w.' , (self findAlloyNameOf: (e subtype)) ].

	self appendFact: (self abstractFact) with: ('all w: World | w.' , (aMocoAlloySignatureField name) , ' = ' , ('+' join: subtypes))
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> generateAbstractFacts: aCollection [
	aCollection do: [ :each | self generateAbstractFactFor: each withField: (engine detectOutputElement: each ofKind: MocoAlloySignatureField) ]
]

{ #category : 'private - transforming' }
MocoO2AClassTransformationRule >> generateExistenceConstraint: aCollection [
	| universals facts |
	universals := Dictionary new.

	universals at: #Object put: (OrderedCollection new);
		at: #Aspect put: (OrderedCollection new).

	(aCollection select: [ :e | self isTopLevel: e ]) do: [ :each |
		| nature |
		nature := self determineNatureOf: each.
		(nature = #Endurant) ifTrue: [ nature := OrderedCollection new add: #Object; add: #Aspect; yourself ]
			ifFalse: [ nature := OrderedCollection new add: nature; yourself ].

		nature do: [ :n |
			(universals includesKey: n) ifFalse: [ universals at: n put: (OrderedCollection new) ].
			(universals at: n) add: each.
		]
	].

	facts := Dictionary new.

	universals keysAndValuesDo: [ :k :v |
		v ifEmpty: [
			facts at: k put: ('no exists:>' , k)
		] ifNotEmpty: [
			facts at: k put: ('exists:>' , k , ' in ' , ('+' join: (v collect: [ :e | self findAlloyNameOf: e ])))
		]
	].

	facts keysAndValuesDo: [ :k :v |
		(self worldSig facts noneSatisfy: [ :f | f body includesSubstring: ('exists:>' , k) ]) ifTrue: [
			self worldSig facts add: (MocoAlloySignatureFact new body: v; yourself).
			engine output setModified
		]
	]
]

{ #category : 'private - transforming' }
MocoO2AClassTransformationRule >> generateFieldSignatureOf: aMocoOntoUmlClass [
	^ 'exists:>' , (self determineNatureOf: aMocoOntoUmlClass)
]

{ #category : 'private - transforming' }
MocoO2AClassTransformationRule >> generateIdentityConstraint: aCollection [
	| classes fact |
	classes := (aCollection select: [ :e | self isTopLevel: e ]) collect: [ :e | self findAlloyNameOf: e ].

	((classes size) < 2) ifTrue: [ ^ self ].

	fact := MocoAlloySignatureFact new.
	fact body: ('disj[' , (', ' join: classes) , ']').

	self worldSig facts add: fact.

	engine output setModified
]

{ #category : 'private - transforming' }
MocoO2AClassTransformationRule >> generateRigidityFactFor: aMocoOntoUmlClass withField: aMocoAlloySignatureField [
	| rigid antiRigid |

	(self isTopLevel: aMocoOntoUmlClass)
		ifFalse: [ ^ self ].

	rigid := self class rigidTypes anySatisfy: [ :t | aMocoOntoUmlClass class == t ].
	antiRigid := self class antiRigidTypes anySatisfy: [ :t | aMocoOntoUmlClass class == t ].

	(rigid and: (antiRigid not)) ifTrue: [
		self appendFact: (self rigidFact) with: ('rigidity[' , (aMocoAlloySignatureField name) , ', ' , (self determineNatureOf: aMocoOntoUmlClass) , ', exists]')
	].

	(antiRigid and: (rigid not)) ifTrue: [
		self appendFact: (self antiRigidFact) with: ('antirigidity[' , (aMocoAlloySignatureField name) , ', ' , (self determineNatureOf: aMocoOntoUmlClass) , ', exists]')
	]
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> generateRigidityFacts: aCollection [
	aCollection do: [ :each | self generateRigidityFactFor: each withField: (engine detectOutputElement: each ofKind: MocoAlloySignatureField) ]
]

{ #category : 'initialization' }
MocoO2AClassTransformationRule >> initialize [
	super initialize.

	natureCache := OrderedCollection new
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> is: anObject aKindOf: aCollection [
	^ aCollection anySatisfy: [ :e | anObject class == e ]
]

{ #category : 'private - processing' }
MocoO2AClassTransformationRule >> isTopLevel: aMocoOntoUmlClass [
	^ engine input elements noneSatisfy: [ :e | (e isKindOf: MocoOntoUmlGeneralization) and: [ e subtype == aMocoOntoUmlClass ] ]
]

{ #category : 'accessing' }
MocoO2AClassTransformationRule >> priority [
	^ 100
]

{ #category : 'private - accessing' }
MocoO2AClassTransformationRule >> rigidFact [
	^ self findFact: 'rigid'
]

{ #category : 'private - transforming' }
MocoO2AClassTransformationRule >> transformClass: aMocoOntoUmlClass [
	| world field |
	world := self worldSig.

	field := MocoAlloySignatureField new.
	field name: (self toAlloyName: (aMocoOntoUmlClass name) ifEmpty: 'class');
		multiplicity: #set;
		signature: (self generateFieldSignatureOf: aMocoOntoUmlClass).

	world fields add: field.

	engine atInput: aMocoOntoUmlClass putOutputElement: field.
	engine output setModified
]
