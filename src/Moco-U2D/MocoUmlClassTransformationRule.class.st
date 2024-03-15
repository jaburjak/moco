"
Transforms UML Classes into Oracle RDB tables.
"
Class {
	#name : #MocoUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'columnDataTypeMapper'
	],
	#category : #'Moco-U2D-Rule'
}

{ #category : #transforming }
MocoUmlClassTransformationRule >> execute [
	| classes |

	classes := (engine inModel elements select: [ :e | e isWrappingType: MocoUmlClass ]) select: [ :e | e meta isNotProcessedBy: #MocoUmlClassTransformationRule ].
	
	classes do: [ :element |
		| outElement outElements |
		outElement := MocoWrappedElement from: (self toTable: element).
		
		engine outModel elements add: outElement.
		
		outElements := OrderedCollection new.
		outElements add: outElement; addAll: (element meta outElements). "make sure MocoRdbTable is first in outElements"
		element meta outElements removeAll.
		element meta outElements addAll: outElements.
		
		element meta markProcessedBy: #MocoUmlClassTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #'private - processing' }
MocoUmlClassTransformationRule >> generateIdentityColumn: aString [
	"Generates an ID column an a PRIMARY KEY for a table with the given name."
	
	| col con |
	col := MocoRdbColumn new.
	
	col name: (aString , '_ID');
		type: (MocoRdbTypeInteger new);
		nullable: false.
		
	con := MocoRdbPrimaryKey new.
	con name: ('PK_' , aString).
	con columns add: col.
	
	^ { col. con }
]

{ #category : #initialization }
MocoUmlClassTransformationRule >> initialize [
	super initialize.
	
	columnDataTypeMapper := MocoUmlToRdbDataTypeMapper new.
]

{ #category : #accessing }
MocoUmlClassTransformationRule >> priority [
	^ 100 
]

{ #category : #'private - processing' }
MocoUmlClassTransformationRule >> resolveClassAttributes: aMocoUmlClass [
	| attributes |
	attributes := OrderedCollection new.
	
	attributes addAll: (aMocoUmlClass attributes).
	
	"((engine inModel elements select: [ :each | each isWrappingType: MocoUmlGeneralization ])
		select: [ :each | (each innerElement subtype) == aMocoUmlClass ])
		do: [ :each |
			(self resolveClassAttributes: (each innerElement supertype)) do: [ :a |
				(attributes contains: [ :e | (e name) = (a name) ])
					ifFalse: [ attributes add: a ]
			]
		]."

	^ attributes
]

{ #category : #'private - processing' }
MocoUmlClassTransformationRule >> resolveColumnType: aMocoUmlType [
	aMocoUmlType ifNil: [ ^ nil ].
	aMocoUmlType name ifEmpty: [ ^ nil ].

	^ (columnDataTypeMapper map: (aMocoUmlType name)) new
]

{ #category : #'private - transforming' }
MocoUmlClassTransformationRule >> toColumn: aMocoUmlAttribute ofTable: aMocoRdbTable ofClass: aMocoWrappedElement [
	| column |

	column := MocoRdbColumn new.
	
	column name: (MocoNamingUtils toUpperSnakeCase: (aMocoUmlAttribute name));
		type: (self resolveColumnType: (aMocoUmlAttribute type)).
		
	(aMocoUmlAttribute multiplicity lower value <= 0)
		ifTrue: [ column nullable: true ]
		ifFalse: [ column nullable: false ].
	
	(aMocoUmlAttribute immutable) ifTrue: [
		| ocl |
		ocl := MocoOclRdbImmutableColumnCondition new.
		ocl name: ('IM_' , (aMocoRdbTable name) , '_' , (column name) , '_UPD');
			context: aMocoRdbTable;
			column: column;
			operation: #UPDATE.
		
		ocl := MocoWrappedElement from: ocl.
		
		aMocoWrappedElement meta outElements add: ocl.
		engine outModel elements add: ocl
	].
	
	^ column
]

{ #category : #'private - transforming' }
MocoUmlClassTransformationRule >> toTable: aMocoWrappedElement [
	| table id |
	table := MocoRdbTable new.
	
	table name: (MocoNamingUtils toUpperSnakeCase: (aMocoWrappedElement innerElement name)).
	
	id := self generateIdentityColumn: (table name).
	
	table columns add: (id first).
	table constraints add: (id last).
	
	table columns addAll: ((self resolveClassAttributes: aMocoWrappedElement innerElement) collect: [ :each | self toColumn: each ofTable: table ofClass: aMocoWrappedElement ]).
	
	^ table
]
