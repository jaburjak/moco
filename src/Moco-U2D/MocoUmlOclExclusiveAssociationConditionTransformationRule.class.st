"
Transforms the OCL invariant for exclusive phase associations from UML context to RDB.
"
Class {
	#name : #MocoUmlOclExclusiveAssociationConditionTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #transforming }
MocoUmlOclExclusiveAssociationConditionTransformationRule >> execute [
	| conditions |
	conditions := engine input
		selectElementsOfKind: MocoOclExclusiveAssociationCondition
		notGuarded: #MocoUmlOclExclusivePhaseConditionTranformationRule.
	
	conditions do: [ :each | self transformCondition: each ]
]

{ #category : #'private - processing' }
MocoUmlOclExclusiveAssociationConditionTransformationRule >> findTableFor: aMocoUmlAssociation [
	"Returns the referencing table and column of the given association."
	
	| referencedTable table column |
	referencedTable := engine detectOutputElement: ((MocoUmlAssociationTransformation findReferencedSideOf: aMocoUmlAssociation) element) ofKind: MocoRdbTable.
	table := engine detectOutputElement: ((MocoUmlAssociationTransformation findReferencingSideOf: aMocoUmlAssociation) element) ofKind: MocoRdbTable.
	
	column := (table constraints select: [ :each |
		(each isKindOf: MocoRdbForeignKey) and: [ (each referencedTable) == referencedTable ]
	]) first columns first.
	
	^ { table. column }
]

{ #category : #accessing }
MocoUmlOclExclusiveAssociationConditionTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoUmlOclExclusiveAssociationConditionTransformationRule >> transformCondition: aMocoOclExclusiveAssociationCondition [
	"Transforms exclusive association OCL constraint to a database model."
	
	| ocl context |
	ocl := MocoOclRdbExclusiveAssociationCondition new.
	
	context := engine detectOutputElement: (aMocoOclExclusiveAssociationCondition context).
	
	ocl name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclExclusiveAssociationCondition name));
		context: context;
		column: ((context constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ]) first columns first).
	
	aMocoOclExclusiveAssociationCondition associations do: [ :each |
		| tables |
		tables := each collect: [ :a | self findTableFor: a ].
		
		ocl referencingTables add: (tables collect: [ :e | e first ]).
		ocl referencingColumns add: (tables collect: [ :e | e last ])
	].

	engine addOutputElement: ocl withSource: aMocoOclExclusiveAssociationCondition.
	engine input guard: aMocoOclExclusiveAssociationCondition with: #MocoUmlOclExclusivePhaseConditionTranformationRule
]
