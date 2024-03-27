"
Transforms UML associations to reference columns.
"
Class {
	#name : #MocoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #'private - testing' }
MocoUmlAssociationTransformationRule >> checkIfOneToOne: aMocoUmlAssociation [
	"Returns true if the given association is of one-to-one kind."
	
	^ (aMocoUmlAssociation source multiplicity upper isSingle) and: [ aMocoUmlAssociation target multiplicity upper isSingle ]
]

{ #category : #transforming }
MocoUmlAssociationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: MocoUmlAssociation
		notGuarded: #MocoUmlAssociationTransformationRule.
	
	associations do: [ :each | self toReferenceColumn: each ]
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> findPrimaryKey: aMocoRdbTable [
	"Returns the PRIMARY KEY constraint of the given table."
	
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ]) first
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> findTableFor: aMocoUmlClass [
	"Returns the database table that was created from the given class."
	
	^ engine detectOutputElement: aMocoUmlClass ofKind: MocoRdbTable
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> generateDeleteConstraintForTable: aMocoRdbTable andColumn: aMocoRdbColumn withTargetTable: aMocoRdbTable2 andColumn: aMocoRdbColumn2 [
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
MocoUmlAssociationTransformationRule >> generateImmutableColumnConstraintForTable: aMocoRdbTable andColumn: aMocoRdbColumn [
	| ocl |
	ocl := MocoOclRdbImmutableColumnCondition new.
	
	ocl name: ('IM_' , (aMocoRdbTable name) , '_' , (aMocoRdbColumn name) , '_UPD');
		context: aMocoRdbTable;
		operation: #UPDATE;
		column: aMocoRdbColumn.
	
	^ ocl
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> generateMandatoryMultiplicityConstraintForSourceTable: aMocoRdbTable andColumn: aMocoRdbColumn andTargetTable: aMocoRdbTable2 andColumn: aMocoRdbColumn2 [
	| ocl |
	ocl := MocoOclRdbMandatoryMultiplicityConstraint new.
	ocl name: ('MUL_' , (aMocoRdbTable name) , '_' , (aMocoRdbColumn name));
		context: aMocoRdbTable2;
		targetColumn: aMocoRdbColumn2;
		sourceTable: aMocoRdbTable;
		sourceColumn: aMocoRdbColumn.
		
	^ ocl
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> generateReferencingColumn: aMocoUmlAssociation [
	"Generates the referencing column at the source table of the given association."
	
	| column referenced referencedTable primaryKey |
	column := MocoRdbColumn new.
	referenced := MocoUmlAssociationTransformation findReferencedSideOf: aMocoUmlAssociation.
	
	referencedTable := self findTableFor: (referenced element).
	primaryKey := self findPrimaryKey: referencedTable.
	
	(referenced name)
		ifNotEmpty: [ column name: (MocoNamingUtils toUpperSnakeCase: (referenced name)) ]
		ifEmpty: [ column name: (primaryKey columns first name) ].
	
	column type: (primaryKey columns first type).
	
	(referenced multiplicity lower isOptional)
		ifTrue: [ column nullable: true ]
		ifFalse: [ column nullable: false ].
		
	^ column
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> generateSpecialMultiplicityConstraintForSourceTable: aMocoRdbTable andColumn: aMocoRdbColumn andTargetTable: aMocoRdbTable2 andColumn: aMocoRdbColumn2 withLower: aNumber andUpper: aNumber2 [
	| ocl |
	ocl := MocoOclRdbSpecialMultiplicityConstraint new.
	ocl name: ('MUL_' , (aMocoRdbTable name) , '_' , (aMocoRdbColumn name));
		context: aMocoRdbTable2;
		targetColumn: aMocoRdbColumn2;
		sourceTable: aMocoRdbTable;
		sourceColumn: aMocoRdbColumn;
		lower: aNumber;
		upper: aNumber2.
		
	^ ocl
	
]

{ #category : #accessing }
MocoUmlAssociationTransformationRule >> priority [
	^ 85
]

{ #category : #'private - transforming' }
MocoUmlAssociationTransformationRule >> toReferenceColumn: aMocoUmlAssociation [
	"Transforms the given association to a reference between two tables."
	
	| column foreignKey referencingSide referencingTable referencedSide referencedTable lowerBound upperBound |
	column := self generateReferencingColumn: aMocoUmlAssociation.
	
	referencingSide := MocoUmlAssociationTransformation findReferencingSideOf: aMocoUmlAssociation.
	referencingTable := self findTableFor: (referencingSide element).
	
	referencedSide := MocoUmlAssociationTransformation findReferencedSideOf: aMocoUmlAssociation.
	referencedTable := self findTableFor: (referencedSide element).
	
	foreignKey := MocoRdbForeignKey newInTable: referencingTable atColumn: column referencingTable: referencedTable andColumn: ((self findPrimaryKey: referencedTable) columns first).
	
	referencingTable columns add: column.
	referencingTable constraints add: foreignKey.
	
	(self checkIfOneToOne: aMocoUmlAssociation) ifTrue: [
		| uniqueKey |
		uniqueKey := MocoRdbUniqueKey new.
		uniqueKey name: ('UQ_' , (referencingTable name) , '_' , (column name)).
		uniqueKey columns add: column.
		referencingTable constraints add: uniqueKey
	].

	((referencingSide multiplicity upper isBounded) and: [ referencingSide multiplicity upper isMultiple ])
		ifTrue: [ upperBound := referencingSide multiplicity upper value ]
		ifFalse: [ upperBound := nil ].
	
	(((referencingSide multiplicity lower isBounded) and: [ referencingSide multiplicity lower isMultiple ]) or: [ (upperBound isNotNil) and: [ referencingSide multiplicity lower isOne ] ] )
		ifTrue: [ lowerBound := referencingSide multiplicity lower value ]
		ifFalse: [ lowerBound := nil ].
	
	((lowerBound isNotNil) or: [ upperBound isNotNil ]) ifTrue: [
			| ocl |
			ocl := self generateSpecialMultiplicityConstraintForSourceTable: referencingTable andColumn: column andTargetTable: referencedTable andColumn: (foreignKey referencedColumns first) withLower: lowerBound andUpper: upperBound.
			
			engine addOutputElement: ocl withSource: aMocoUmlAssociation
		]
		ifFalse: [
			(referencingSide multiplicity lower isOne) ifTrue: [
				| ocl |
				ocl := self generateMandatoryMultiplicityConstraintForSourceTable: referencingTable andColumn: column andTargetTable: referencedTable andColumn: (foreignKey referencedColumns first).
				
				engine addOutputElement: ocl withSource: aMocoUmlAssociation
			]
		].

	((referencedSide frozen) or: [ referencingSide frozen ]) ifTrue: [
		| ocl |
		ocl := self generateImmutableColumnConstraintForTable: referencingTable andColumn: column.
		
		engine addOutputElement: ocl withSource: aMocoUmlAssociation
	].

	(referencingSide frozen) ifTrue: [
		| ocl |
		ocl := self generateDeleteConstraintForTable: referencingTable andColumn: column withTargetTable: referencedTable andColumn: (foreignKey referencedColumns first).
		
		engine addOutputElement: ocl withSource: aMocoUmlAssociation
	].
	
	engine input guard: aMocoUmlAssociation with: #MocoUmlAssociationTransformationRule
]
