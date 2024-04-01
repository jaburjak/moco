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
	classes := engine input
		selectElementsOfKind: MocoUmlClass
		notGuarded: #MocoUmlClassTransformationRule.
	
	classes do: [ :each | self transformClass: each ]
]

{ #category : #'private - processing' }
MocoUmlClassTransformationRule >> generateIdentityColumn: aMocoRdbTable [
	"Generates an ID column and a PRIMARY KEY for the given table.
	 In case a column with name 'ID' already exists, it will be returned instead of generating a new one."
	
	| col con |
	col := aMocoRdbTable columns detect: [ :each | each name = 'ID' ] ifNone: [
		MocoRdbColumn new
			name: ((aMocoRdbTable name) , '_ID');
			type: (MocoRdbTypeInteger new);
			nullable: false;
			yourself
	].
	
	con := MocoRdbPrimaryKey new.
	con name: ('PK_' , (aMocoRdbTable name)).
	con columns add: col.
	
	^ { col. con }
]

{ #category : #initialization }
MocoUmlClassTransformationRule >> initialize [
	super initialize.
	
	columnDataTypeMapper := MocoUmlToRdbDataTypeMapper instance
]

{ #category : #accessing }
MocoUmlClassTransformationRule >> priority [
	^ 100 
]

{ #category : #'private - processing' }
MocoUmlClassTransformationRule >> resolveColumnType: aMocoUmlType [
	"Returns the database type corresponding to the given object model type."
	
	aMocoUmlType ifNil: [ ^ nil ].
	aMocoUmlType name ifEmpty: [ ^ nil ].

	^ (columnDataTypeMapper map: (aMocoUmlType name)) new
]

{ #category : #'private - transforming' }
MocoUmlClassTransformationRule >> toColumn: aMocoUmlAttribute ofTable: aMocoRdbTable ofClass: aMocoUmlClass [
	"Returns a table column and its OCL constraints created from the given class attribute."

	| column constraints |
	column := MocoRdbColumn new.
	constraints := OrderedCollection new.
	
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
		
		constraints add: ocl
	].
	
	^ { column. constraints }
]

{ #category : #'private - transforming' }
MocoUmlClassTransformationRule >> toTable: aMocoUmlClass [
	"Returns a table and additional OCL constraints created from the given class."

	| table id columns |
	table := MocoRdbTable new.
	
	table name: (MocoNamingUtils toUpperSnakeCase: (aMocoUmlClass name)).
	
	columns := (aMocoUmlClass attributes) collect: [ :each | self toColumn: each ofTable: table ofClass: aMocoUmlClass ].
	table columns addAll: (columns collect: [ :each | each first ]).
	
	id := self generateIdentityColumn: table.
	
	(table columns noneSatisfy: [ :each | each == (id first) ]) ifTrue: [ table columns addFirst: (id first) ].
	table constraints addFirst: (id last).
	
	^ { table. columns flatCollect: [ :each | each second ] }
]

{ #category : #'private - transforming' }
MocoUmlClassTransformationRule >> transformClass: aMocoUmlClass [
	"Transforms the given class to a database table."
	
	| table |
	table := self toTable: aMocoUmlClass.
	
	engine addOutputElement: (table first) withSource: aMocoUmlClass.
	
	table second do: [ :each | engine addOutputElement: each withSource: aMocoUmlClass ].
	
	engine input guard: aMocoUmlClass with: #MocoUmlClassTransformationRule
]
