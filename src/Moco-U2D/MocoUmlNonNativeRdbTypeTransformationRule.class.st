"
Transforms class attributes with non-database-native types into associations.
"
Class {
	#name : #MocoUmlNonNativeRdbTypeTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'dataTypeMapper'
	],
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #'private - processing' }
MocoUmlNonNativeRdbTypeTransformationRule >> checkIfDecompositionNeeded: aMocoUmlClass [
	"Returns true if the class contains any non-database-native attribute."
	
	 ^ aMocoUmlClass attributes anySatisfy: [ :each | (self checkIfTypeIsNative: (each type)) not ]
]

{ #category : #'private - processing' }
MocoUmlNonNativeRdbTypeTransformationRule >> checkIfTypeIsNative: aMocoUmlType [
	"Returns true if the given data type can be represented as a regular database column."
	
	aMocoUmlType ifNil: [ ^ true ].
	
	((engine input elements) anySatisfy: [ :each | ((each isKindOf: MocoUmlClass) or: [ each isKindOf: MocoUmlEnumeration ]) and: [ (each name) = (aMocoUmlType name) ] ])
		ifTrue: [ ^ false ].
	
	^ (dataTypeMapper map: (aMocoUmlType name)) isNotNil
]

{ #category : #'private - transforming' }
MocoUmlNonNativeRdbTypeTransformationRule >> decomposeAttribute: aMocoUmlAttribute ofClass: aMocoUmlClass [
	"Transforms the given attribute to an association."
	
	| association source target |
	association := MocoUmlAssociation new.
	
	source := MocoUmlAssociationSide new.
	source element: aMocoUmlClass.
	source multiplicity lower value: 0.
	source multiplicity upper value: nil.

	target := MocoUmlAssociationSide new.
	target element: (self resolveAssociationTarget: aMocoUmlAttribute type);
		name: (MocoNamingUtils toCamelCase: (aMocoUmlAttribute name));
		visibility: (aMocoUmlAttribute visibility).
	target multiplicity lower value: (aMocoUmlAttribute multiplicity lower value).
	target multiplicity upper value: (aMocoUmlAttribute multiplicity upper value).
	
	aMocoUmlAttribute immutable ifTrue: [ target frozen: true ].
	
	association name: (MocoNamingUtils toCamelCase: ((aMocoUmlClass name) , ' ' , (aMocoUmlAttribute name)));
		source: source;
		target: target.
		
	^ association
]

{ #category : #'private - transforming' }
MocoUmlNonNativeRdbTypeTransformationRule >> decomposeAttributesOn: aMocoUmlClass [
	"Transforms attributes that reference another class to associations."
	
	| attributes |
	
	engine output guard: aMocoUmlClass with: #MocoUmlNonNativeRdbTypeTransformationRule.
	
	(self checkIfDecompositionNeeded: aMocoUmlClass) ifFalse: [ ^ self ].
	
	attributes := OrderedCollection new.
	
	aMocoUmlClass attributes do: [ :each |
		(self checkIfTypeIsNative: (each type))
			ifTrue: [ attributes add: each ]
			ifFalse: [
				| association |
				association := self decomposeAttribute: each ofClass: aMocoUmlClass.
				
				engine addOutputElement: association withSource: (engine detectInputElement: aMocoUmlClass)
			]
	].
	
	aMocoUmlClass attributes removeAll.
	aMocoUmlClass attributes addAll: attributes.
	
	engine output setModified
]

{ #category : #transforming }
MocoUmlNonNativeRdbTypeTransformationRule >> execute [
	| classes |
	classes := engine output
		selectElementsOfKind: MocoUmlClass
		notGuarded: #MocoUmlNonNativeRdbTypeTransformationRule.
	
	classes := classes select: [ :each | (engine detectInputElement: each) isNotNil ]. "isNotNil check ignores classes generated in this transformation phase"
	
	classes do: [ :each |
		self decomposeAttributesOn: each
	]
]

{ #category : #initialization }
MocoUmlNonNativeRdbTypeTransformationRule >> initialize [
	super initialize.
	
	dataTypeMapper := MocoUmlToRdbDataTypeMapper instance
]

{ #category : #accessing }
MocoUmlNonNativeRdbTypeTransformationRule >> priority [
	^ 25
]

{ #category : #'private - processing' }
MocoUmlNonNativeRdbTypeTransformationRule >> resolveAssociationTarget: aMocoUmlType [
	"Returns the class that the given data type is referencing."
	
	^ (engine output elements)
		detect: [ :each | ((each isKindOf: MocoUmlClass) or: [ each isKindOf: MocoUmlEnumeration ]) and: [ (each name) = (aMocoUmlType name) ] ]
		ifNone: [ self error: ('Unrecognized attribute data type: ' , (aMocoUmlType name)) ]
]
