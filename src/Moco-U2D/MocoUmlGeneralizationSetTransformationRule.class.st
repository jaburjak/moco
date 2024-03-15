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
	| sets |
	sets := engine inModel elements select: [ :each | (each isWrappingType: MocoUmlGeneralizationSet) and: [ each meta isNotProcessedBy: #MocoUmlGeneralizationSetTransformationRule ] ].
	
	sets do: [ :each |
		self transformToReferencingTables: each.
		
		each meta markProcessedBy: #MocoUmlGeneralizationSetTransformationRule
	].

	sets ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoUmlGeneralizationSetTransformationRule >> generateConstraint: aMocoUmlGeneralizationSet inTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| ocl name i params |
	
	i := 1.
	name := 'GS_' , (aMocoUmlGeneralizationSet members first supertype name).
	aMocoUmlGeneralizationSet name ifNotEmpty: [ name := name , '_' , (aMocoUmlGeneralizationSet name) ].
	[ engine outModel elements anySatisfy: [ :each | (each isWrappingType: MocoOclRdbGeneralizationSetConstraint) and: [ (each innerElement name) = (name , ((i > 1) ifTrue: [ i asString ] ifFalse: [ '' ])) ] ] ]
		whileTrue: [ i := i + 1 ].
	name := name , ((i > 1) ifTrue: [ i asString ] ifFalse: [ '' ]).
	
	ocl := MocoOclRdbGeneralizationSetConstraint new.
	
	ocl name: name;
		context: aMocoRdbTable;
		column: aMocoRdbColumn.
	
	ocl tables addAll: (aMocoUmlGeneralizationSet members collect: [ :each |
		| table foreignKey |
		table := ((engine findOutElementsFor: (each subtype)) select: [ :e | e isWrappingType: MocoRdbTable ]) first innerElement.
		foreignKey := ((engine findOutElementsFor: each) select: [ :e | e isWrappingType: MocoRdbForeignKey ]) first innerElement.
		
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
	| i name |
	i := 1.
	name := 'DISCRIMINATOR'.
	
	aMocoUmlGeneralizationSet name ifNotEmpty: [
		name := 'DISCR_' , (MocoNamingUtils toUpperSnakeCase: (aMocoUmlGeneralizationSet name)).
	].
	
	[ aMocoRdbTable columns anySatisfy: [ :each | (each name) = (name , ((i > 1) ifTrue: [ i asString ] ifFalse: [ '' ])) ] ] whileTrue: [ i := i + 1 ].
	
	^ (name , ((i > 1) ifTrue: [ i asString ] ifFalse: [ '' ]))
]

{ #category : #'private - processing' }
MocoUmlGeneralizationSetTransformationRule >> generateInstanceCombinations: aMocoUmlGeneralizationSet withTables: anOrderedCollection [
	| combinations |
	combinations := OrderedCollection new.
	
	combinations addAll: (aMocoUmlGeneralizationSet members collect: [ :each |
		| table |
		table := ((engine findOutElementsFor: (each subtype)) select: [ :e | e isWrappingType: MocoRdbTable ]) first innerElement.
		
		{
			each subtype name.
			anOrderedCollection collect: [ :e | e == table ]
		}
	]).

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
	
	dataTypeMapper := MocoUmlToRdbDataTypeMapper new
]

{ #category : #accessing }
MocoUmlGeneralizationSetTransformationRule >> priority [
	^ 89
]

{ #category : #'private - transforming' }
MocoUmlGeneralizationSetTransformationRule >> transformToReferencingTables: aMocoWrappedElement [
	| general column constraint |
	general := ((engine findOutElementsFor: (aMocoWrappedElement innerElement members first supertype)) select: [ :each | each isWrappingType: MocoRdbTable ]) first innerElement.
	column := self generateDiscriminatorColumn: (aMocoWrappedElement innerElement) inTable: general.
	
	general columns add: column.
	
	constraint := self generateConstraint: (aMocoWrappedElement innerElement) inTable: general withColumn: column.
	constraint := MocoWrappedElement from: constraint.
	
	engine outModel elements add: constraint.
	
	aMocoWrappedElement meta outElements add: (MocoWrappedElement from: column).
	aMocoWrappedElement meta outElements add: constraint
]
