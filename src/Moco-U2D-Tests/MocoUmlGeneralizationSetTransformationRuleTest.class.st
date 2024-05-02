Class {
	#name : #MocoUmlGeneralizationSetTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'general',
		'members'
	],
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #'private - processing' }
MocoUmlGeneralizationSetTransformationRuleTest >> execute [
	^ self execute: MocoUmlGeneralizationSetTransformationRule
]

{ #category : #running }
MocoUmlGeneralizationSetTransformationRuleTest >> setUp [
	super setUp.
	
	general := { MocoUmlClass new name: 'General'; yourself. MocoRdbTable new name: 'GENERAL'; yourself }.
	general second columns add: (MocoRdbColumn new name: 'GENERAL_ID'; type: (MocoRdbTypeInteger new); yourself).
	general second constraints add: (MocoRdbPrimaryKey new name: 'PK_GENERAL_ID'; yourself).
	general second constraints first columns add: (general second columns first).
	engine input addElement: (general first).
	engine addOutputElement: (general second) withSource: (general first).
	
	members := {
		OrderedCollection with: (MocoUmlClass new name: 'A'; yourself).
		OrderedCollection with: (MocoUmlClass new name: 'B'; yourself)
	}.
	
	members do: [ :each |
		each add: (MocoRdbTable new name: (each first name); yourself).
		each second columns add: (MocoRdbColumn new name: (each second name , '_ID'); type: (MocoRdbTypeInteger new); yourself).
		each second constraints add: (MocoRdbPrimaryKey new name: ('PK_' , each second columns first name); yourself).
		each second constraints first columns add: (each second columns first).
		engine input addElement: (each first).
		engine addOutputElement: (each second) withSource: (each first).
		
		each add: (MocoUmlGeneralization new supertype: (general first); subtype: (each first); yourself).
		engine input addElement: (each at: 3).
		
		each second constraints add: (MocoRdbForeignKey new name: ('FK_' , each second name , '_ID'); yourself).
		each second constraints second referencedTable: (general second).
		each second constraints second referencedColumns add: (general second columns first).
		each second constraints second columns add: (each second columns first).
		engine input at: (each at: 3) putOutputElement: (each second constraints second)
	]
]

{ #category : #tests }
MocoUmlGeneralizationSetTransformationRuleTest >> testDisjointCovering [
	| set discr ocl |
	set := MocoUmlGeneralizationSet new name: 'GenSet'; disjoint: true; covering: true; yourself.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	self execute.
	
	self assert: (general second columns size) equals: 2.
	discr := general second columns second.
	
	self assert: (discr name) equals: 'DISCR_GEN_SET';
		assert: (discr type isKindOf: MocoRdbTypeVarchar);
		assert: (discr type length) equals: 1;
		assert: (discr nullable) equals: false.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbGeneralizationSetConstraint ].
	self assert: (ocl size) equals: 1.
	ocl := ocl first.
	
	self assert: (ocl name) equals: 'GS_General_GenSet';
		assert: (ocl context) identicalTo: (general second);
		assert: (ocl discriminatorColumn) identicalTo: discr;
		assert: (ocl keyColumn) identicalTo: (general second columns first);
		assert: (ocl tables size) equals: 2;
		assert: (ocl tables first first) identicalTo: (members first second);
		assert: (ocl tables first second) identicalTo: (members first second columns first);
		assert: (ocl tables second first) identicalTo: (members second second);
		assert: (ocl tables second second) identicalTo: (members second second columns first);
		assert: (ocl values) equals: (OrderedCollection with: 'A' with: 'B');
		assert: (ocl configurations size) equals: 2;
		assert: (ocl configurations first) equals: (OrderedCollection with: true with: false);
		assert: (ocl configurations second) equals: (OrderedCollection with: false with: true)
]

{ #category : #tests }
MocoUmlGeneralizationSetTransformationRuleTest >> testDisjointIncomplete [
	| set ocl |
	set := MocoUmlGeneralizationSet new name: 'GenSet'; disjoint: true; covering: false; yourself.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	self execute.
	
	self assert: (general second columns second type length) equals: 7.
	
	ocl := engine output elements detect: [ :each | each isKindOf: MocoOclRdbGeneralizationSetConstraint ].
	
	self assert: (ocl values) equals: (OrderedCollection with: 'General' with: 'A' with: 'B');
		assert: (ocl configurations size) equals: 3;
		assert: (ocl configurations first) equals: (OrderedCollection with: false with: false);
		assert: (ocl configurations second) equals: (OrderedCollection with: true with: false);
		assert: (ocl configurations at: 3) equals: (OrderedCollection with: false with: true)
]

{ #category : #tests }
MocoUmlGeneralizationSetTransformationRuleTest >> testMultiple [
	| set set2 ocl |
	set := MocoUmlGeneralizationSet new disjoint: true; covering: true; yourself.
	set members add: (members first at: 3).
	
	set2 := MocoUmlGeneralizationSet new disjoint: true; covering: true; yourself.
	set2 members add: (members second at: 3).
	
	(engine input) addElement: set; addElement: set2.
	
	self execute; execute.
	
	self assert: (general second columns size) equals: 3;
		assert: (general second columns second name) equals: 'DISCRIMINATOR';
		assert: ((general second columns at: 3) name) equals: 'DISCRIMINATOR2'.
	
	ocl := engine output elements select: [ :each | each isKindOf: MocoOclRdbGeneralizationSetConstraint ].
	
	self assert: (ocl size) equals: 2;
		assert: (ocl first name) equals: 'GS_General_Type';
		assert: (ocl second name) equals: 'GS_General_Type2'
]

{ #category : #tests }
MocoUmlGeneralizationSetTransformationRuleTest >> testOverlappingComplete [
	| set ocl |
	set := MocoUmlGeneralizationSet new name: 'GenSet'; disjoint: false; covering: true; yourself.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	self execute.
	
	self assert: (general second columns second type length) equals: 2.
	
	ocl := engine output elements detect: [ :each | each isKindOf: MocoOclRdbGeneralizationSetConstraint ].
	
	self assert: (ocl values) equals: (OrderedCollection with: 'A' with: 'B' with: 'AB');
		assert: (ocl configurations size) equals: 3;
		assert: (ocl configurations first) equals: (OrderedCollection with: true with: false);
		assert: (ocl configurations second) equals: (OrderedCollection with: false with: true);
		assert: (ocl configurations at: 3) equals: (OrderedCollection with: true with: true)
]

{ #category : #tests }
MocoUmlGeneralizationSetTransformationRuleTest >> testOverlappingIncomplete [
	| set ocl |
	set := MocoUmlGeneralizationSet new name: 'GenSet'; disjoint: false; covering: false; yourself.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	self execute.
	
	self assert: (general second columns second type length) equals: 7.
	
	ocl := engine output elements detect: [ :each | each isKindOf: MocoOclRdbGeneralizationSetConstraint ].
	
	self assert: (ocl values) equals: (OrderedCollection with: 'General' with: 'A' with: 'B' with: 'AB');
		assert: (ocl configurations size) equals: 4;
		assert: (ocl configurations first) equals: (OrderedCollection with: false with: false);
		assert: (ocl configurations second) equals: (OrderedCollection with: true with: false);
		assert: (ocl configurations at: 3) equals: (OrderedCollection with: false with: true);
		assert: (ocl configurations at: 4) equals: (OrderedCollection with: true with: true)
]

{ #category : #tests }
MocoUmlGeneralizationSetTransformationRuleTest >> testUnnamed [
	| set discr ocl |
	set := MocoUmlGeneralizationSet new yourself disjoint: true; covering: true; yourself.
	members do: [ :each | set members add: (each at: 3) ].
	
	engine input addElement: set.
	
	self execute.
	
	self assert: (general second columns size) equals: 2.
	discr := general second columns second.
	
	self assert: (discr name) equals: 'DISCRIMINATOR'.
	
	ocl := engine output elements detect: [ :each | each isKindOf: MocoOclRdbGeneralizationSetConstraint ].
	
	self assert: (ocl name) equals: 'GS_General_Type'
]
