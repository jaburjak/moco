Class {
	#name : #MocoUmlOclExclusiveAssociationConditionTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'source',
		'members'
	],
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #'private - processing' }
MocoUmlOclExclusiveAssociationConditionTransformationRuleTest >> execute [
	^ self execute: MocoUmlOclExclusiveAssociationConditionTransformationRule
]

{ #category : #running }
MocoUmlOclExclusiveAssociationConditionTransformationRuleTest >> setUp [
	super setUp.
	
	source := { MocoUmlClass new name: 'TestClass'; yourself. MocoRdbTable new name: 'TEST_CLASS'; yourself }.
	source second columns add: (MocoRdbColumn new name: 'TEST_CLASS_ID'; type: (MocoRdbTypeInteger new); yourself).
	source second constraints add: (MocoRdbPrimaryKey new name: 'PK_TEST_CLASS'; yourself).
	source second constraints first columns add: (source second columns first).
	engine input addElement: (source first).
	engine addOutputElement: (source second) withSource: (source first).
	
	members := {
		OrderedCollection with: (MocoUmlClass new name: 'A'; yourself).
		OrderedCollection with: (MocoUmlClass new name: 'B'; yourself)
	}.
	
	members do: [ :each |
		each add: (MocoRdbTable new name: (each first name); yourself).
		each second columns add: (MocoRdbColumn new name: (each second name , '_ID'); type: (MocoRdbTypeInteger new); yourself).
		each second constraints add: (MocoRdbPrimaryKey new name: ('PK_' , each second name); yourself).
		each second constraints first columns add: (each second columns first).
		engine input addElement: (each first).
		engine addOutputElement: (each second) withSource: (each first).
		
		each add: (MocoUmlAssociation new).
		(each at: 3) source element: (each first).
		(each at: 3) target element: (source first).
		engine input addElement: (each at: 3).
		
		each second columns add: (MocoRdbColumn new name: (source second columns first name); type: (source second columns first type); yourself).
		each second constraints add: (MocoRdbForeignKey new name: ('FK_' , each second name , '_' , each second columns last name); yourself).
		each second constraints last columns add: (each second columns last).
		each second constraints last referencedTable: (source second).
		each second constraints last referencedColumns add: (source second columns first).
		engine input at: (each at: 3) putOutputElement: (each second constraints last)
	]
]

{ #category : #tests }
MocoUmlOclExclusiveAssociationConditionTransformationRuleTest >> testOcl [
	| ocl ocl2 |
	ocl := MocoOclExclusiveAssociationCondition new name: 'TestOcl'; context: (source first); yourself.
	members do: [ :each | ocl associations add: { each at: 3 } ].
	
	engine input addElement: ocl.
	
	self execute.
	
	ocl2 := engine output elements select: [ :each | each isKindOf: MocoOclRdbExclusiveAssociationCondition ].
	self assert: (ocl2 size) equals: 1.
	ocl2 := ocl2 first.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoOclExclusiveAssociationCondition ]).
	
	self assert: (ocl2 name) equals: (ocl name);
		assert: (ocl2 context) identicalTo: (source second);
		assert: (ocl2 column) identicalTo: (source second columns first);
		assert: (ocl2 referencingTables size) equals: 2;
		assert: (ocl2 referencingTables first asOrderedCollection) equals: (OrderedCollection with: (members first second));
		assert: (ocl2 referencingTables second asOrderedCollection) equals: (OrderedCollection with: (members second second));
		assert: (ocl2 referencingColumns size) equals: 2;
		assert: (ocl2 referencingColumns first asOrderedCollection) equals: (OrderedCollection with: (members first second columns second));
		assert: (ocl2 referencingColumns second asOrderedCollection) equals: (OrderedCollection with: (members second second columns second))
]
