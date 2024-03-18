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
	 ^ aMocoUmlClass attributes anySatisfy: [ :each | (self checkIfTypeIsNative: (each type)) not ]
]

{ #category : #'private - processing' }
MocoUmlNonNativeRdbTypeTransformationRule >> checkIfTypeIsNative: aMocoUmlType [
	(engine inModel elements anySatisfy: [ :each | (each isWrappingType: MocoUmlClass) and: [ (each innerElement name) = (aMocoUmlType name) ] ])
		ifTrue: [ ^ false ].
	
	^ (dataTypeMapper map: (aMocoUmlType name)) isNotNil
]

{ #category : #'private - processing' }
MocoUmlNonNativeRdbTypeTransformationRule >> decomposeAttribute: aMocoUmlAttribute ofClass: aMocoWrappedElement [
	| association source target |
	association := MocoUmlAssociation new.
	
	source := MocoUmlAssociationSide new.
	source element: (aMocoWrappedElement innerElement);
		name: (MocoNamingUtils toCamelCase: (aMocoWrappedElement innerElement name)).
	source multiplicity lower value: 1.
	source multiplicity upper value: 1.
	source visibility: (aMocoUmlAttribute visibility).

	target := MocoUmlAssociationSide new.
	target element: (self resolveAssociationTarget: aMocoUmlAttribute type);
		name: (MocoNamingUtils toCamelCase: (aMocoUmlAttribute name)).
	target multiplicity lower value: (aMocoUmlAttribute multiplicity lower value).
	target multiplicity upper value: (aMocoUmlAttribute multiplicity upper value).
	
	aMocoUmlAttribute immutable ifTrue: [ target frozen: true ].
	
	association name: (MocoNamingUtils toCamelCase: ((aMocoWrappedElement innerElement name) , ' ' , (aMocoUmlAttribute name)));
		source: source;
		target: target.
		
	^ association
]

{ #category : #'private - transforming' }
MocoUmlNonNativeRdbTypeTransformationRule >> decomposeAttributesOn: aMocoWrappedElement [
	| attributes |
	
	(engine findInElementFor: aMocoWrappedElement) meta markProcessedBy: #MocoUmlNonNativeRdbTypeTransformationRule.
	
	(self checkIfDecompositionNeeded: (aMocoWrappedElement innerElement)) ifFalse: [ ^ self ].
	
	attributes := OrderedCollection new.
	
	aMocoWrappedElement innerElement attributes do: [ :each |
		(self checkIfTypeIsNative: (each type))
			ifTrue: [ attributes add: each ]
			ifFalse: [
				| association element |
				association := self decomposeAttribute: each ofClass: aMocoWrappedElement.
				element := MocoWrappedElement from: association.
				
				engine outModel elements add: element.
				aMocoWrappedElement meta outElements add: element
			]
	].

	aMocoWrappedElement innerElement attributes removeAll.
	aMocoWrappedElement innerElement attributes addAll: attributes.

	engine outModel meta didChange: true
]

{ #category : #transforming }
MocoUmlNonNativeRdbTypeTransformationRule >> execute [
	| classes |
	classes := engine outModel elements select: [ :each |
		(each isWrappingType: MocoUmlClass) and: [ ((engine findInElementFor: each) meta isProcessedBy: #MocoUmlNonNativeRdbTypeTransformationRule) not] 
	].
	
	classes do: [ :each |
		self decomposeAttributesOn: each
	]
]

{ #category : #initialization }
MocoUmlNonNativeRdbTypeTransformationRule >> initialize [
	super initialize.
	
	dataTypeMapper := MocoUmlToRdbDataTypeMapper new.
]

{ #category : #accessing }
MocoUmlNonNativeRdbTypeTransformationRule >> priority [
	^ 25
]

{ #category : #'private - processing' }
MocoUmlNonNativeRdbTypeTransformationRule >> resolveAssociationTarget: aMocoUmlType [
	| candidates |
	candidates := engine outModel elements select: [ :each | (each isWrappingType: MocoUmlClass) and: [ (each innerElement name) = (aMocoUmlType name) ] ].
	
	candidates ifEmpty: [ ^ self error: ('Unrecognized attribute data type: ' , (aMocoUmlType name)) ].
	
	^ candidates first innerElement
]
