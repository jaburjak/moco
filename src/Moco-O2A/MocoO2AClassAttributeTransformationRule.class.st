"
Transforms attributes defined in OntoUML classes to an Alloy specification.
"
Class {
	#name : 'MocoO2AClassAttributeTransformationRule',
	#superclass : 'MocoO2ATransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'private - processing' }
MocoO2AClassAttributeTransformationRule >> determineCardinality: aMocoOntoUmlAttribute [
	| mult |
	mult := #set.
	aMocoOntoUmlAttribute multiplicity lower isOptional ifTrue: [
		aMocoOntoUmlAttribute multiplicity upper isSingle ifTrue: [ mult := #lone ]
	] ifFalse: [
		aMocoOntoUmlAttribute multiplicity upper isSingle
			ifTrue: [ mult := #one ] ifFalse: [ #some ]
	].

	^ mult
]

{ #category : 'private - processing' }
MocoO2AClassAttributeTransformationRule >> determineTypeName: aMocoOntoUmlAttribute [
	| type |
	type := engine input elements select: [ :e | (e isKindOf: MocoOntoUmlClass) and: [ (e name) = (aMocoOntoUmlAttribute type name) ] ].
	type ifEmpty: [ type := nil ] ifNotEmpty: [ type := ('World.' , (engine detectOutputElement: (type first) ofKind: MocoAlloySignatureField) name) ].

	type ifNil: [
		type := MocoNamingUtils toFirstUpperCase: (aMocoOntoUmlAttribute type name).
		(type = 'Integer') ifTrue: [ type := 'Int' ]
	].

	^ type
]

{ #category : 'transforming' }
MocoO2AClassAttributeTransformationRule >> execute [
	| classes |
	classes := engine input
		selectElementsOfKind: MocoOntoUmlClass
		notGuarded: #MocoO2AClassAttributeTransformationRule.
	
	classes do: [ :each | self transformAttributesOf: each ].

	classes do: [ :each | engine input guard: each with: #MocoO2AClassAttributeTransformationRule ]
]

{ #category : 'private - transforming' }
MocoO2AClassAttributeTransformationRule >> generateFunctionFor: aMocoOntoUmlAttribute of: aMocoAlloySignatureField withField: aMocoAlloySignatureField2 [
	| name fun |
	aMocoOntoUmlAttribute name
		ifNotEmpty: [
			name := aMocoAlloySignatureField name , '_' , aMocoOntoUmlAttribute name , 'Fn'
		] ifEmpty: [
			name := aMocoAlloySignatureField2 name , 'Fn'
		].

	fun := MocoAlloyFunction new
		name: (self toLowerAlloyName: name);
		output: ('set ' , (self determineTypeName: aMocoOntoUmlAttribute));
		body: ('x.(w.' , (aMocoAlloySignatureField2 name) , ')');
		yourself.

	(fun arguments)
		add: 'x' ofType: ('World.' , (aMocoAlloySignatureField name));
		add: 'w' ofType: 'World'.

	engine addOutputElement: fun.

	^ fun
]

{ #category : 'private - transforming' }
MocoO2AClassAttributeTransformationRule >> generateImmutabilityConstraintFor: aMocoAlloySignatureField fromAttr: aMocoOntoUmlAttribute of: aMocoOntoUmlClass [
	| fact |
	aMocoOntoUmlAttribute immutable ifFalse: [ ^ self ].

	fact := self findFact: 'associationProperties'.

	self appendFact: fact with: ('immutable_target[' , ((engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField) name) , ', ' , (aMocoAlloySignatureField name) , ']').
	engine output setModified
]

{ #category : 'private - transforming' }
MocoO2AClassAttributeTransformationRule >> generateMultiplicityFactFor: aMocoOntoUmlAttribute of: aMocoAlloySignatureField withFunction: aMocoAlloyFunction [
	| clauses |
	clauses := OrderedCollection new.

	aMocoOntoUmlAttribute multiplicity lower isMandatory ifTrue: [
		aMocoOntoUmlAttribute multiplicity lower isOne ifFalse: [
			clauses add: ('#' , (aMocoAlloyFunction name) , '[x, w] >= ' , (aMocoOntoUmlAttribute multiplicity lower value asString))
		]
	].

	aMocoOntoUmlAttribute multiplicity upper isBounded ifTrue: [
		aMocoOntoUmlAttribute multiplicity upper isOne ifFalse: [
			clauses add: ('#' , (aMocoAlloyFunction name) , '[x, w] <= ' , (aMocoOntoUmlAttribute multiplicity upper value asString))
		]
	].

	clauses ifEmpty: [ ^ self ].

	self appendFact: (self findFact: 'multiplicity')
		with: ('all w: World, x: World.' , (aMocoAlloySignatureField name) , ' | (' , (' and ' join: clauses) , ')')
]

{ #category : 'accessing' }
MocoO2AClassAttributeTransformationRule >> priority [
	^ 99
]

{ #category : 'private - transforming' }
MocoO2AClassAttributeTransformationRule >> transformAttribute: aMocoOntoUmlAttribute of: aMocoOntoUmlClass [
	| cls sig field |
	cls := engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField.

	sig := (cls name) , ' set -> '.
	aMocoOntoUmlAttribute ordered ifTrue: [ sig := sig , 'set Int set -> ' ].
	sig := sig , (self determineCardinality: aMocoOntoUmlAttribute) , ' ' , (self determineTypeName: aMocoOntoUmlAttribute).

	field := MocoAlloySignatureField new
		name: (self toLowerAlloyName: (aMocoOntoUmlAttribute name ifNotEmpty: [ cls name , '_' , aMocoOntoUmlAttribute name ]) ifEmpty: (cls name , '_attribute'));
		signature: sig;
		yourself.

	(self worldSig) fields add: field.
	engine output setModified.

	self generateMultiplicityFactFor: aMocoOntoUmlAttribute of: cls withFunction: (self generateFunctionFor: aMocoOntoUmlAttribute of: cls withField: field);
		generateImmutabilityConstraintFor: field fromAttr: aMocoOntoUmlAttribute of: aMocoOntoUmlClass
]

{ #category : 'private - transforming' }
MocoO2AClassAttributeTransformationRule >> transformAttributesOf: aMocoOntoUmlClass [
	aMocoOntoUmlClass attributes do: [ :e | self transformAttribute: e of: aMocoOntoUmlClass ]
]
