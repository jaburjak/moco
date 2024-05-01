Class {
	#name : #MocoOntoUmlGeneralizationSetTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'general',
		'members'
	],
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #execution }
MocoOntoUmlGeneralizationSetTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlGeneralizationSetTransformationRule
]

{ #category : #running }
MocoOntoUmlGeneralizationSetTransformationRuleTest >> setUp [
	super setUp.
	
	general := { MocoOntoUmlClass new name: 'General'; yourself. MocoUmlClass new name: 'General'; yourself }.
	
	engine input addElement: (general first).
	engine addOutputElement: (general second) withSource: (general first).
	
	members := OrderedCollection
		with: { MocoOntoUmlClass new name: 'A'; yourself }
		with: { MocoOntoUmlClass new name: 'B'; yourself }.
		
	members := members collect: [ :each |
		| member |
		member := each asOrderedCollection.
		
		member add: (MocoUmlClass new name: (member first name); yourself);
			add: (MocoOntoUmlGeneralization new supertype: (general first); subtype: (member first); yourself);
			add: (MocoUmlGeneralization new supertype: (general second); subtype: (member second); yourself).
		
		(engine input) addElement: (member first); addElement: (member at: 3).
		
		engine addOutputElement: (member second) withSource: (member first);
			addOutputElement: (member at: 4) withSource: (member at: 3).
		
		member
	]
]

{ #category : #tests }
MocoOntoUmlGeneralizationSetTransformationRuleTest >> testDiscriminator [
	| set attr ocl |
	set := MocoOntoUmlGeneralizationSet new disjoint: false; covering: false; yourself.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	engine choiceAnswer: #optimize.
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoUmlGeneralizationSet ]).
	
	self assert: (general second attributes size) equals: 1.
	
	attr := general second attributes first.
	
	self assert: (attr name) equals: 'discriminator';
		assert: (attr type name) equals: 'String';
		assert: (attr immutable) equals: true;
		assert: (attr multiplicity lower value) equals: 1;
		assert: (attr multiplicity upper value) equals: 1.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclEnumerationConstraint ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl context) identicalTo: (general second);
		assert: (ocl name) equals: 'EN_General_Discriminator';
		assert: (ocl attribute) identicalTo: attr;
		assert: (ocl values) equals: ({ 'General'. 'A'. 'B'. 'AB' } asOrderedCollection)
]

{ #category : #tests }
MocoOntoUmlGeneralizationSetTransformationRuleTest >> testEmptyGenSet [
	| set |
	set := MocoOntoUmlGeneralizationSet new.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	members do: [ :each | engine removeOutputElement: (each at: 4) ].
	
	engine choiceAnswer: #keep.
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoUmlGeneralizationSet ])
]

{ #category : #tests }
MocoOntoUmlGeneralizationSetTransformationRuleTest >> testGenSet [
	| set set2 |
	set := MocoOntoUmlGeneralizationSet new.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	engine choiceAnswer: #keep.
	self execute.
	
	set2 := engine output elements select: [ :each | each isKindOf: MocoUmlGeneralizationSet ].
	self assert: (set2 size) equals: 1.
	set2 := set2 first.
	
	self assert: (set2 members size) equals: (set members size);
		assert: (set2 disjoint) equals: (set disjoint);
		assert: (set2 covering) equals: (set covering).
	
	members do: [ :each | self assert: (set2 members anySatisfy: [ :e | e == (each at: 4) ]) ]
]

{ #category : #tests }
MocoOntoUmlGeneralizationSetTransformationRuleTest >> testIncompleteOverlapping [
	| set set2 |
	set := MocoOntoUmlGeneralizationSet new disjoint: false; covering: false; yourself.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	engine choiceAnswer: #keep.
	self execute.
	
	set2 := engine output elements detect: [ :each | each isKindOf: MocoUmlGeneralizationSet ].
	
	self assert: (set2 disjoint) equals: (set disjoint);
		assert: (set2 covering) equals: (set covering)
]
