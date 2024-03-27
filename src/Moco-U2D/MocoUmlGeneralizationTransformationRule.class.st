"
Transforms generalizations in a UML model into references between tables in a relational database.
"
Class {
	#name : #MocoUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #transforming }
MocoUmlGeneralizationTransformationRule >> execute [
	| generalizations |
	generalizations := engine input
		selectElementsOfKind: MocoUmlGeneralization
		notGuarded: #MocoUmlGeneralizationTransformationRule.
	
	generalizations do: [ :each | self transformToReferencingTables: each ]
]

{ #category : #'private - processing' }
MocoUmlGeneralizationTransformationRule >> findPrimaryKey: aMocoRdbTable [
	"Returns the PRIMARY KEY constraint of the given table."
	
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ]) first
]

{ #category : #'private - processing' }
MocoUmlGeneralizationTransformationRule >> findTableFor: aMocoUmlClass [
	"Returns the database table that was created from the given class."
	
	^ engine detectOutputElement: aMocoUmlClass ofKind: MocoRdbTable
]

{ #category : #'private - processing' }
MocoUmlGeneralizationTransformationRule >> generateDeleteConstraintForTable: aMocoRdbTable andColumn: aMocoRdbColumn withTargetTable: aMocoRdbTable2 andColumn: aMocoRdbColumn2 [
	| ocl |
	ocl := MocoOclRdbImmutableAssociationDeleteCondition new.
	
	ocl name: ('IM_' , (aMocoRdbTable name) , '_' , (aMocoRdbColumn name) , '_DEL');
		context: aMocoRdbTable;
		operation: #DELETE;
		column: aMocoRdbColumn;
		targetTable: aMocoRdbTable2;
		targetColumn: aMocoRdbColumn2.
	
	^ ocl
]

{ #category : #'private - processing' }
MocoUmlGeneralizationTransformationRule >> generateImmutabilityConstraint: aMocoRdbTable onColumn: aMocoRdbColumn [
	| ocl |
	ocl := MocoOclRdbImmutableColumnCondition new.
	
	ocl name: ('IM_' , (aMocoRdbTable name) , '_' , (aMocoRdbColumn name) , '_UPD');
		context: aMocoRdbTable;
		operation: #UPDATE;
		column: aMocoRdbColumn.
	
	^ ocl
]

{ #category : #accessing }
MocoUmlGeneralizationTransformationRule >> priority [
	^ 90
]

{ #category : #'private - transforming' }
MocoUmlGeneralizationTransformationRule >> transformToReferencingTables: aMocoUmlGeneralization [
	"Transforms a UML generalization to referencing tables database realization."
	
	| general specific primaryKey foreignKey targetOcl sourceOcl |
	general := self findTableFor: (aMocoUmlGeneralization supertype).
	specific := self findTableFor: (aMocoUmlGeneralization subtype).
	
	primaryKey := self findPrimaryKey: general.
	
	foreignKey := MocoRdbForeignKey newInTable: specific atColumn: ((self findPrimaryKey: specific) columns first) referencingTable: general andColumn: (primaryKey columns first).
	foreignKey name: ('FK_' , (specific name) , '_' , (primaryKey columns first name)).
	
	specific constraints add: foreignKey.
	
	targetOcl := self generateImmutabilityConstraint: specific onColumn: (foreignKey columns first).
	sourceOcl := self generateDeleteConstraintForTable: specific andColumn: (foreignKey columns first) withTargetTable: (foreignKey referencedTable) andColumn: (foreignKey referencedColumns first).
	
	engine input at: aMocoUmlGeneralization putOutputElement: foreignKey.
	engine addOutputElement: targetOcl withSource: aMocoUmlGeneralization;
		addOutputElement: sourceOcl withSource: aMocoUmlGeneralization.
	
	engine input guard: aMocoUmlGeneralization with: #MocoUmlGeneralizationTransformationRule
]
