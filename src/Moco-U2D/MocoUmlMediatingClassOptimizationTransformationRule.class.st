"
Changes the primary key of tables realizing a many-to-many relationship.
"
Class {
	#name : #MocoUmlMediatingClassOptimizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #'private - testing' }
MocoUmlMediatingClassOptimizationTransformationRule >> checkIfOptimizable: aMocoRdbTable [
	"Returns true if the given table was generated when decomposing a many-to-many association."
	
	^ (engine selectInputElements: aMocoRdbTable) anySatisfy: [ :each | (engine input metaOf: each at: #generatedBy) = #MocoUmlManyToManyAssociationTransformationRule ]
]

{ #category : #transforming }
MocoUmlMediatingClassOptimizationTransformationRule >> execute [
	| tables |
	tables := engine output
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoUmlMediatingClassOptimizationTransformationRule.
	
	tables do: [ :each |
		(self checkIfOptimizable: each) ifTrue: [
			self optimizeMediatingTable: each
		].
		
		engine output guard: each with: #MocoUmlMediatingClassOptimizationTransformationRule
	]
]

{ #category : #'private - processing' }
MocoUmlMediatingClassOptimizationTransformationRule >> findPrimaryKeyOf: aMocoRdbTable [
	"Returns the PRIMARY KEY constraint of the given table."
	
	^ aMocoRdbTable constraints detect: [ :e | e isKindOf: MocoRdbPrimaryKey ]
]

{ #category : #'private - transforming' }
MocoUmlMediatingClassOptimizationTransformationRule >> optimizeMediatingTable: aMocoRdbTable [
	"Removes generated ID column from a table that is mediating a many-to-many association."
	
	| primaryKey constraint |
	primaryKey := self findPrimaryKeyOf: aMocoRdbTable.
	
	aMocoRdbTable constraints removeAllSuchThat: [ :e | e == primaryKey ].
	aMocoRdbTable columns removeAllSuchThat: [ :e | primaryKey columns anySatisfy: [ :p | p == e ] ].
	
	constraint := MocoRdbPrimaryKey new.
	constraint name: (primaryKey name).
	constraint columns addAll: (aMocoRdbTable constraints flatCollect: [ :e | e columns ]).
	
	aMocoRdbTable constraints add: constraint.
	
	engine output setModified
]

{ #category : #accessing }
MocoUmlMediatingClassOptimizationTransformationRule >> priority [
	^ 35
]
