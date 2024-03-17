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
	generalizations := engine inModel elements select: [ :each | (each isWrappingType: MocoUmlGeneralization) and: [ (each meta isProcessedBy: #MocoUmlGeneralizationTransformationRule) not ] ].
	
	generalizations do: [ :each |
		self transformToReferencingTables: each.
		
		each meta markProcessedBy: #MocoUmlGeneralizationTransformationRule
	].

	generalizations ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoUmlGeneralizationTransformationRule >> findPrimaryKey: aMocoRdbTable [
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ]) first
]

{ #category : #'private - processing' }
MocoUmlGeneralizationTransformationRule >> findTableFor: aMocoUmlClass [
	^ ((engine findOutElementsFor: aMocoUmlClass) select: [ :each | each isWrappingType: MocoRdbTable ]) first innerElement
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
MocoUmlGeneralizationTransformationRule >> transformToReferencingTables: aMocoWrappedElement [
	| general specific primaryKey foreignKey targetOcl sourceOcl |
	general := self findTableFor: (aMocoWrappedElement innerElement supertype).
	specific := self findTableFor: (aMocoWrappedElement innerElement subtype).
	
	primaryKey := self findPrimaryKey: general.
	
	foreignKey := MocoRdbForeignKey newAtColumn: ((self findPrimaryKey: specific) columns first) referencingTable: general andColumn: (primaryKey columns first).
	foreignKey name: ('FK_' , (specific name) , '_' , (primaryKey columns first name)).
	
	specific constraints add: foreignKey.
	
	targetOcl := self generateImmutabilityConstraint: specific onColumn: (foreignKey columns first).
	targetOcl := MocoWrappedElement from: targetOcl.
	
	sourceOcl := self generateDeleteConstraintForTable: specific andColumn: (foreignKey columns first) withTargetTable: (foreignKey reference first first) andColumn: (foreignKey reference first last).
	sourceOcl := MocoWrappedElement from: sourceOcl.
	
	aMocoWrappedElement meta outElements addAll: { (MocoWrappedElement from: foreignKey). targetOcl. sourceOcl }.
	
	engine outModel elements addAll: { targetOcl. sourceOcl }
]
