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
	^ (aMocoUmlAssociation source multiplicity upper isSingle) and: [ aMocoUmlAssociation target multiplicity upper isSingle ]
]

{ #category : #transforming }
MocoUmlAssociationTransformationRule >> execute [
	| associations |
	associations := engine inModel elements select: [ :each | (each isWrappingType: MocoUmlAssociation) and: [ (each meta isProcessedBy: #MocoUmlAssociationTransformationRule) not ] ].
	
	associations do: [ :each | self toReferenceColumn: each ].
	
	associations ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> findPrimaryKey: aMocoRdbTable [
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ]) first
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> findReferencedSideOf: aMocoUmlAssociation [
	"Returns the referenced (target) side of the association."
	
	| referencing |
	referencing := self findReferencingSideOf: aMocoUmlAssociation.
	
	((aMocoUmlAssociation source) == referencing) ifTrue: [ ^ (aMocoUmlAssociation target) ].
	
	^ (aMocoUmlAssociation source)
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> findReferencingSideOf: aMocoUmlAssociation [
	"Returns the referencing (source) side of the association."
	
	(aMocoUmlAssociation source multiplicity upper isMultiple)
		ifTrue: [ ^ (aMocoUmlAssociation source) ]. "many-to-one"
	
	(aMocoUmlAssociation target multiplicity upper isMultiple)
		ifTrue: [ ^ (aMocoUmlAssociation target) ]. "one-to-many"
	
	((aMocoUmlAssociation source multiplicity lower isOptional) and: [ aMocoUmlAssociation target multiplicity lower isMandatory ])
		ifTrue: [ ^ (aMocoUmlAssociation source) ]. "one[0..1]-to-one[1..1]"
	
	((aMocoUmlAssociation source multiplicity lower isMandatory) and: [ aMocoUmlAssociation target multiplicity lower isOptional ])
		ifTrue: [ ^ (aMocoUmlAssociation target) ]. "one[1..1]-to-one[0..1]"
	
	^ (aMocoUmlAssociation source) "one[0..0]-to-one[0..0] or one[1..1]-to-one[1..1]"
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> findTableFor: aMocoUmlClass [
	^ (((engine findOutElementsFor: aMocoUmlClass) select: [ :each | each isWrappingType: MocoRdbTable ]) first) innerElement
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
	ocl := MocoOclMandatoryMultiplicityConstraint new.
	ocl name: ('MUL_' , (aMocoRdbTable name) , '_' , (aMocoRdbColumn name));
		context: aMocoRdbTable2;
		targetColumn: aMocoRdbColumn2;
		sourceTable: aMocoRdbTable;
		sourceColumn: aMocoRdbColumn.
		
	^ ocl
]

{ #category : #'private - processing' }
MocoUmlAssociationTransformationRule >> generateReferencingColumn: aMocoUmlAssociation [
	| column referenced referencedTable primaryKey |
	column := MocoRdbColumn new.
	referenced := self findReferencedSideOf: aMocoUmlAssociation.
	
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
	ocl := MocoOclSpecialMultiplicityConstraint new.
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
MocoUmlAssociationTransformationRule >> toReferenceColumn: aMocoWrappedElement [
	| column foreignKey referencingSide referencingTable referencedSide referencedTable n m |
	column := self generateReferencingColumn: (aMocoWrappedElement innerElement).
	
	referencingSide := self findReferencingSideOf: (aMocoWrappedElement innerElement).
	referencingTable := self findTableFor: (referencingSide element).
	
	referencedSide := self findReferencedSideOf: (aMocoWrappedElement innerElement).
	referencedTable := self findTableFor: (referencedSide element).
	
	foreignKey := MocoRdbForeignKey newAtColumn: column referencingTable: referencedTable andColumn: ((self findPrimaryKey: referencedTable) columns first).
	
	referencingTable columns add: column.
	referencingTable constraints add: foreignKey.
	
	(self checkIfOneToOne: (aMocoWrappedElement innerElement)) ifTrue: [
		| uniqueKey |
		uniqueKey := MocoRdbUniqueKey new.
		uniqueKey name: ('UQ_' , (column name)).
		uniqueKey columns add: column.
		referencingTable constraints add: uniqueKey
	].

	(referencingSide multiplicity lower isOne) ifTrue: [
		| ocl |
		ocl := self generateMandatoryMultiplicityConstraintForSourceTable: referencingTable andColumn: column andTargetTable: referencedTable andColumn: (foreignKey columns first).
		ocl := MocoWrappedElement from: ocl.
		
		aMocoWrappedElement meta outElements add: ocl.
		engine outModel elements add: ocl
	].

	((referencingSide multiplicity upper isBounded) and: [ referencingSide multiplicity upper isMultiple ])
		ifTrue: [ m := referencingSide multiplicity upper value ]
		ifFalse: [ m := nil ].
	
	((referencingSide multiplicity lower isBounded) and: [ referencingSide multiplicity lower isMultiple ] )
		ifTrue: [ n := referencingSide multiplicity lower value ]
		ifFalse: [ n := nil ].
	
	((n isNotNil) or: [ m isNotNil ]) ifTrue: [
		| ocl |
		ocl := self generateSpecialMultiplicityConstraintForSourceTable: referencingTable andColumn: column andTargetTable: referencedTable andColumn: (foreignKey columns first) withLower: n andUpper: m.
		ocl := MocoWrappedElement from: ocl.
		
		aMocoWrappedElement meta outElements add: ocl.
		engine outModel elements add: ocl
	].

	((referencedSide frozen) or: [ referencingSide frozen ]) ifTrue: [
		| ocl |
		ocl := self generateImmutableColumnConstraintForTable: referencingTable andColumn: column.
		ocl := MocoWrappedElement from: ocl.
		
		aMocoWrappedElement meta outElements add: ocl.
		engine outModel elements add: ocl
	].

	(referencingSide frozen) ifTrue: [
		| ocl |
		ocl := self generateDeleteConstraintForTable: referencingTable andColumn: column withTargetTable: referencedTable andColumn: (foreignKey columns first).
		ocl := MocoWrappedElement from: ocl.
		
		aMocoWrappedElement meta outElements add: ocl.
		engine outModel elements add: ocl
	].
	
	aMocoWrappedElement meta markProcessedBy: #MocoUmlAssociationTransformationRule
]