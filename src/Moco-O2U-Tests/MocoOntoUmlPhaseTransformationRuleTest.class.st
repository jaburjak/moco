Class {
	#name : #MocoOntoUmlPhaseTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlPhaseTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlPhaseTransformationRule
]

{ #category : #tests }
MocoOntoUmlPhaseTransformationRuleTest >> testAp [
	| kind kind2 phases generalizations set association abstract set2 |
	kind := MocoOntoUmlKind new.
	phases := OrderedCollection with: (MocoOntoUmlPhase new name: 'P1'; yourself) with: (MocoOntoUmlPhase new name: 'P2'; yourself).
	generalizations := phases collect: [ :each | MocoOntoUmlGeneralization new supertype: kind; subtype: each; yourself ].
	set := MocoOntoUmlGeneralizationSet new name: 'TestPhase'; disjoint: true; covering: true; yourself.
	set members addAll: generalizations.
	
	engine input addElement: kind.
	phases do: [ :each | engine input addElement: each ].
	generalizations do: [ :each | engine input addElement: each ].
	engine input addElement: set.
	
	kind2 := MocoUmlClass new.
	engine addOutputElement: kind2 withSource: kind.
	
	engine choiceAnswer: #ap.
	
	self execute.
	
	association := engine output elements select: [ :each | (each isKindOf: MocoUmlAssociation) ].
	self assert: (association size) equals: 1.
	association := association first.
	self assert: (association target element) identicalTo: kind2;
		assert: (association target multiplicity lower value) equals: 1;
		assert: (association target multiplicity upper value) equals: 1;
		assert: (association target frozen) equals: true;
		assert: (association target name) equals: 'identityBearer';
		assert: (association source element isKindOf: MocoUmlClass);
		assert: (association source multiplicity lower value) equals: 1;
		assert: (association source multiplicity upper value) equals: 1;
		assert: (association source frozen) equals: false;
		assert: (association source name) equals: 'condition';
		assert: (association name) equals: 'testPhase'.
	
	abstract := association source element.
	self assert: (abstract abstract) equals: true;
		assert: (abstract name) equals: (kind name , set name).
	
	set2 := engine output elements select: [ :each | each isKindOf: MocoUmlGeneralizationSet ].
	self assert: (set2 size) equals: 1.
	set2 := set2 first.
	self assert: (set2 name) equals: (set name);
		assert: (set2 disjoint) equals: true;
		assert: (set2 covering) equals: true;
		assert: (set2 members size) equals: (set members size).
	
	phases do: [ :each |
		| phase generalization |
		phase := engine output elements select: [ :e | (e isKindOf: MocoUmlClass) and: [ (e name) = (each name) ] ].
		self assert: (phase size) equals: 1.
		phase := phase first.
		self assert: (phase isKindOf: MocoUmlClass).
		generalization := engine output elements select: [ :e | (e isKindOf: MocoUmlGeneralization) and: [ (e subtype) == phase ] ].
		self assert: (generalization size) equals: 1.
		generalization := generalization first.
		self assert: (generalization supertype) identicalTo: abstract
	]
]

{ #category : #tests }
MocoOntoUmlPhaseTransformationRuleTest >> testAttribute [
	| kind kind2 phases generalizations set attr ocl |
	kind := MocoOntoUmlKind new name: 'Kind'; yourself.
	phases := OrderedCollection with: (MocoOntoUmlPhase new name: 'P1'; yourself) with: (MocoOntoUmlPhase new name: 'P2'; yourself).
	generalizations := phases collect: [ :each | MocoOntoUmlGeneralization new supertype: kind; subtype: each; yourself ].
	set := MocoOntoUmlGeneralizationSet new disjoint: true; covering: true; yourself.
	set members addAll: generalizations.
	
	engine input addElement: kind.
	phases do: [ :each | engine input addElement: each ].
	generalizations do: [ :each | engine input addElement: each ].
	engine input addElement: set.
	
	kind2 := MocoUmlClass new name: 'Kind'; yourself.
	engine addOutputElement: kind2 withSource: kind.
	
	engine choiceAnswer: #attr.
	
	self execute.
	
	self assert: ((engine output elements select: [ :each | each isKindOf: MocoUmlClass ]) size) equals: 1.
	
	attr := kind2 attributes.
	self assert: (attr size) equals: 1.
	attr := attr first.
	self assert: (attr type name) equals: 'String';
		assert: (attr multiplicity lower value) equals: 1;
		assert: (attr multiplicity upper value) equals: 1;
		assert: (attr immutable) equals: false;
		assert: (attr name) equals: 'phase'.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclEnumerationConstraint ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	self assert: (ocl context) identicalTo: kind2;
		assert: (ocl attribute) identicalTo: attr;
		assert: (ocl name) equals: 'EN_Kind_Phase_Condition';
		assert: (ocl values size) equals: (generalizations size).
	
	phases do: [ :each | self assert: (ocl values includes: (each name)) ]
]

{ #category : #tests }
MocoOntoUmlPhaseTransformationRuleTest >> testEpa [
	| kind kind2 phases generalizations set ocl |
	kind := MocoOntoUmlKind new name: 'Kind'; yourself.
	phases := OrderedCollection with: (MocoOntoUmlPhase new name: 'P1'; yourself) with: (MocoOntoUmlPhase new name: 'P2'; yourself).
	generalizations := phases collect: [ :each | MocoOntoUmlGeneralization new supertype: kind; subtype: each; yourself ].
	set := MocoOntoUmlGeneralizationSet new disjoint: true; covering: true; yourself.
	set members addAll: generalizations.
	
	engine input addElement: kind.
	phases do: [ :each | engine input addElement: each ].
	generalizations do: [ :each | engine input addElement: each ].
	engine input addElement: set.
	
	kind2 := MocoUmlClass new name: 'Kind'; yourself.
	engine addOutputElement: kind2 withSource: kind.
	
	engine choiceAnswer: #epa.
	
	self execute.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclExclusiveAssociationCondition ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	self assert: (ocl context) identicalTo: kind2;
		assert: (ocl associations size) equals: (phases size);
		assert: (ocl name) equals: 'EX_Kind_Phase_Condition'.
	
	phases do: [ :each |
		| phase association |
		phase := engine output elements select: [ :e | (e isKindOf: MocoUmlClass) and: [ (e name) = (each name) ] ].
		self assert: (phase size) equals: 1.
		phase := phase first.
		self assert: (phase isKindOf: MocoUmlClass).
		association := engine output elements select: [ :e | (e isKindOf: MocoUmlAssociation) and: [ (e target element) == phase ] ].
		self assert: (association size) equals: 1.
		association := association first.
		self assert: (ocl associations anySatisfy: [ :e | ((e size) = 1) and: [ (e first) == association ] ]);
			assert: (association source element) identicalTo: kind2;
			assert: (association source multiplicity lower value) equals: 1;
			assert: (association source multiplicity upper value) equals: 1;
			assert: (association source frozen) equals: true;
			assert: (association source name) equals: 'identityBearer';
			assert: (association target multiplicity lower value) equals: 0;
			assert: (association target multiplicity upper value) equals: 1;
			assert: (association target frozen) equals: false;
			assert: (association target name) equals: 'phase';
			assert: (association name) equals: (phase name asLowercase)
	]
]

{ #category : #tests }
MocoOntoUmlPhaseTransformationRuleTest >> testNonPhasePartition [
	| mixin phase generalization set mixin2 |
	mixin := MocoOntoUmlPhaseMixin new.
	phase := MocoOntoUmlPhase new.
	generalization := MocoOntoUmlGeneralization new supertype: mixin; subtype: phase; yourself.
	set := MocoOntoUmlGeneralizationSet new disjoint: true; covering: true; yourself.
	set members add: generalization.
	
	(engine input) addElement: mixin; addElement: phase; addElement: generalization; addElement: set.
	
	mixin2 := MocoUmlClass new abstract: true; yourself.
	
	engine addOutputElement: mixin2 withSource: mixin.
	
	engine choiceAnswer: #epa.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoOclExclusiveAssociationCondition ] )
]
