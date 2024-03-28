"
Transforms generalization sets from a UML model to a relation database model.
"
Class {
	#name : #MocoUmlGeneralizationSetTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'dataTypeMapper'
	],
	#category : #'Moco-U2D-Rule'
}

{ #category : #transforming }
MocoUmlGeneralizationSetTransformationRule >> execute [
	| generalizationSets |
	generalizationSets := engine input
		selectElementsOfKind: MocoUmlGeneralizationSet
		notGuarded: #MocoUmlGeneralizationSetTransformationRule.
	
	generalizationSets do: [ :each | self transformToReferencingTables: each ]
]

{ #category : #'private - processing' }
MocoUmlGeneralizationSetTransformationRule >> generateConstraint: aMocoUmlGeneralizationSet inTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	"Returns a generalization set OCL constraint for the given generalization set."
	
	| ocl name params |
	
	name := 'GS_' , (aMocoUmlGeneralizationSet members first supertype name).
	aMocoUmlGeneralizationSet name ifNotEmpty: [ name := name , '_' , (aMocoUmlGeneralizationSet name) ].
	name := MocoUniqueNameGenerator
		at: [ :candidate | (engine output selectElementsOfKind: MocoOclRdbGeneralizationSetConstraint) anySatisfy: [ :each | (each name) = candidate ] ]
		seed: name.
	
	ocl := MocoOclRdbGeneralizationSetConstraint new.
	
	ocl name: (MocoNamingUtils toUpperSnakeCase: name);
		context: aMocoRdbTable;
		discriminatorColumn: aMocoRdbColumn;
		keyColumn: ((aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ]) first columns first).
	
	ocl tables addAll: (aMocoUmlGeneralizationSet members collect: [ :each |
		| table foreignKey |
		table := engine detectOutputElement: (each subtype) ofKind: MocoRdbTable.
		foreignKey := engine detectOutputElement: each ofKind: MocoRdbForeignKey.
		
		{ table. (foreignKey columns first) }
	]).
	
	params := OrderedCollection new.
	
	aMocoUmlGeneralizationSet ifNotCovering: [
		params add: {
			(aMocoUmlGeneralizationSet members first supertype name).
			ocl tables collect: [ :each | false ]
		}
	].

	params addAll: (self generateInstanceCombinations: aMocoUmlGeneralizationSet withTables: (ocl tables collect: [ :each | each first ])).
	
	params do: [ :each |
		ocl values add: each first.
		ocl configurations add: each last
	].
	
	^ ocl
]

{ #category : #'private - processing' }
MocoUmlGeneralizationSetTransformationRule >> generateDiscriminatorColumn: aMocoUmlGeneralizationSet inTable: aMocoRdbTable [
	"Returns a discriminator column for the given generalization set."
	
	| type column lengths |
	type := (dataTypeMapper map: 'String') new.
	
	lengths := OrderedCollection new.
	lengths add: (aMocoUmlGeneralizationSet members first supertype name size).
	
	aMocoUmlGeneralizationSet ifDisjoint: [
		lengths addAll: (aMocoUmlGeneralizationSet members collect: [ :each | each subtype name size ])
	].

	aMocoUmlGeneralizationSet ifNotDisjoint: [ 
		lengths addAll: (((aMocoUmlGeneralizationSet members collect: [ :each | each subtype name size ]) combinations) collect: [ :each | each sum ])
	].
	
	type length: (lengths max).
	
	column := MocoRdbColumn new.
	column name: (self generateDiscriminatorName: aMocoUmlGeneralizationSet inTable: aMocoRdbTable);
		type: type;
		nullable: false.
	
	^ column
]

{ #category : #'private - processing' }
MocoUmlGeneralizationSetTransformationRule >> generateDiscriminatorName: aMocoUmlGeneralizationSet inTable: aMocoRdbTable [
	"Generates a unique discriminator column name for the given generalization set in the given table."
	
	| name |
	name := 'DISCRIMINATOR'.
	
	aMocoUmlGeneralizationSet name ifNotEmpty: [
		name := 'DISCR_' , (MocoNamingUtils toUpperSnakeCase: (aMocoUmlGeneralizationSet name)).
	].

	^ MocoUniqueNameGenerator
		at: [ :candidate | aMocoRdbTable columns anySatisfy: [ :each | (each name) = candidate ] ]
		seed: name
]

{ #category : #'private - processing' }
MocoUmlGeneralizationSetTransformationRule >> generateInstanceCombinations: aMocoUmlGeneralizationSet withTables: anOrderedCollection [
	"Generates instance combinations for the generalization set OCL constraint."
	"The return value is a collection of collections. The second-level collection contains the value of the discriminator column
	 as the first item, and a collection of true/false values as the second item. The OCL constraint contains a list of all
	 participating tables, the collection of true/false values indicates (in the same order) whether the table is participating
	 at the given discriminator column value."
	
	| combinations |
	combinations := OrderedCollection new.
	
	combinations addAll: (aMocoUmlGeneralizationSet members collect: [ :each |
		| table |
		table := engine detectOutputElement: (each subtype) ofKind: MocoRdbTable.
		
		{
			each subtype name.
			anOrderedCollection collect: [ :e | e == table ]
		}
	]).

	combinations sort: [ :a :b | (a first) < (b first) ].

	aMocoUmlGeneralizationSet ifNotDisjoint: [
		| tmp |
		tmp := combinations combinations collect: [ :each |
			{
				'' join: (each collect: [ :e | e first ]).
				(each collect: [ :e | e last ]) inject: (anOrderedCollection collect: [ :e | false ]) into: [ :s :e | s with: e collect: [ :x :y | x or: [ y ] ] ]
			}
		].
	
		combinations removeAll.
		combinations addAll: tmp
	].

	^ combinations
]

{ #category : #initialization }
MocoUmlGeneralizationSetTransformationRule >> initialize [
	super initialize.
	
	dataTypeMapper := MocoUmlToRdbDataTypeMapper instance
]

{ #category : #accessing }
MocoUmlGeneralizationSetTransformationRule >> priority [
	^ 89
]

{ #category : #'private - transforming' }
MocoUmlGeneralizationSetTransformationRule >> transformToReferencingTables: aMocoUmlGeneralizationSet [
	"Transforms the given generalization set to a discriminator column."
	
	| general column constraint |
	general := engine detectOutputElement: (aMocoUmlGeneralizationSet members first supertype) ofKind: MocoRdbTable.
	column := self generateDiscriminatorColumn: aMocoUmlGeneralizationSet inTable: general.
	
	general columns add: column.
	
	constraint := self generateConstraint: aMocoUmlGeneralizationSet inTable: general withColumn: column.
	
	engine input at: aMocoUmlGeneralizationSet putOutputElement: column.
	engine addOutputElement: constraint withSource: aMocoUmlGeneralizationSet.
	
	engine input guard: aMocoUmlGeneralizationSet with: #MocoUmlGeneralizationSetTransformationRule
]
