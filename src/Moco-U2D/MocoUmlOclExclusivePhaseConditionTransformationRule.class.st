"
Transforms the OCL invariant for exclusive phase associations from UML context to RDB.
"
Class {
	#name : #MocoUmlOclExclusivePhaseConditionTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #transforming }
MocoUmlOclExclusivePhaseConditionTransformationRule >> execute [
	| conditions |
	conditions := engine inModel elements select: [ :each | (each isWrappingType: MocoOclExclusiveAssociationCondition) and: [ each meta isNotProcessedBy: #MocoUmlOclExclusivePhaseConditionTranformationRule ] ].
	
	conditions do: [ :each | self transformCondition: each ].
	
	conditions ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #'private - processing' }
MocoUmlOclExclusivePhaseConditionTransformationRule >> findTableFor: aMocoUmlAssociation [
	| table column |
	
	table := (engine findOutElementsFor: (aMocoUmlAssociation target element)) first innerElement.
	
	column := (table constraints select: [ :each |
		(each isKindOf: MocoRdbForeignKey) and: [ (each reference first first) == ((engine findOutElementsFor: (aMocoUmlAssociation source element)) first innerElement) ]
	]) first columns first.

	^ { table. column }
]

{ #category : #accessing }
MocoUmlOclExclusivePhaseConditionTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoUmlOclExclusivePhaseConditionTransformationRule >> transformCondition: aMocoWrappedElement [
	| ocl context out |
	ocl := MocoOclRdbExclusiveAssociationCondition new.
	
	context := (engine findOutElementsFor: (aMocoWrappedElement innerElement context)) first innerElement.
	
	ocl name: (aMocoWrappedElement innerElement name);
		context: context;
		column: ((context constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ]) first columns first).
	
	aMocoWrappedElement innerElement associations do: [ :each |
		| table |
		table := self findTableFor: each.
		
		ocl referencingTables add: (table first).
		ocl referencingColumns add: (table last)
	].
	
	out := MocoWrappedElement from: ocl.
	
	aMocoWrappedElement meta outElements add: out.
	aMocoWrappedElement meta markProcessedBy: #MocoUmlOclExclusivePhaseConditionTranformationRule.
	
	engine outModel elements add: out
]
