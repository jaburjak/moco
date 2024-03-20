"
Changes the primary key of tables realizing a many-to-many relationship.
"
Class {
	#name : #MocoUmlMediatingClassOptimizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #'private - processing' }
MocoUmlMediatingClassOptimizationTransformationRule >> checkIfOptimizable: aMocoWrappedElement [
	| in |
	in := engine findInElementFor: aMocoWrappedElement.
	
	in ifNil: [ ^ false ].
	
	^ (in meta at: #generatedBy) = #MocoUmlManyToManyAssociationTransformationRule
]

{ #category : #transforming }
MocoUmlMediatingClassOptimizationTransformationRule >> execute [
	| tables |
	tables := engine outModel elements select: [ :each | (each isWrappingType: MocoRdbTable) and: [ each meta isNotProcessedBy: #MocoUmlMediatingClassOptimizationTransformationRule ] ].
	
	tables do: [ :each |
		(self checkIfOptimizable: each) ifTrue: [
				| primaryKey constraint |
				primaryKey := self findPrimaryKeyOf: (each innerElement).
				
				each innerElement constraints removeAllSuchThat: [ :e | e == primaryKey ].
				each innerElement columns removeAllSuchThat: [ :e | primaryKey columns anySatisfy: [ :p | p == e ] ].
				
				constraint := MocoRdbPrimaryKey new.
				constraint name: (primaryKey name).
				constraint columns addAll: (each innerElement constraints flatCollect: [ :e | e columns ]).
				
				each innerElement constraints add: constraint
			].
		
		each meta markProcessedBy: #MocoUmlMediatingClassOptimizationTransformationRule
	].
]

{ #category : #'private - processing' }
MocoUmlMediatingClassOptimizationTransformationRule >> findPrimaryKeyOf: aMocoRdbTable [
	^ aMocoRdbTable constraints detect: [ :e | e isKindOf: MocoRdbPrimaryKey ]
]

{ #category : #accessing }
MocoUmlMediatingClassOptimizationTransformationRule >> priority [
	^ 35
]
