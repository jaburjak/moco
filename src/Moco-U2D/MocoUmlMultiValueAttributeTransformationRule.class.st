"
Transforms multivalue attributes to a generated class and an association.
"
Class {
	#name : #MocoUmlMultiValueAttributeTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #'private - processing' }
MocoUmlMultiValueAttributeTransformationRule >> checkIfMultiValue: aMocoUmlAttribute [
	"Returns true if the maximal multiplicity of the given attribute is greater than one."
	
	^ (aMocoUmlAttribute multiplicity upper isUnbounded or: [ aMocoUmlAttribute multiplicity upper value > 1 ])
]

{ #category : #'private - transforming' }
MocoUmlMultiValueAttributeTransformationRule >> decomposeAttribute: aMocoUmlAttribute ofClass: aMocoUmlClass [
	"Transforms the given attribute to a separate class and association."
	
	| inElement class association |
	class := self generateClassForAttribute: aMocoUmlAttribute ofClass: aMocoUmlClass.
	association := self generateAssociationFrom: aMocoUmlClass to: class forAttribute: aMocoUmlAttribute.
	
	inElement := engine detectInputElement: aMocoUmlClass.
	
	engine addOutputElement: class withSource: inElement;
		addOutputElement: association withSource: inElement.
	
	((engine output selectElementsOfKind: MocoOclEnumerationConstraint)
		select: [ :each | ((each attribute) == aMocoUmlAttribute) and: [ (each context) == aMocoUmlClass ] ])
		do: [ :each |
			each context: (class);
				attribute: (class attributes first)
		]
]

{ #category : #'private - transforming' }
MocoUmlMultiValueAttributeTransformationRule >> decomposeAttributesOn: aMocoUmlClass [
	"Transforms attributes with greater than one maximal multiplicity to a separate class."
	
	| attributes |
	attributes := aMocoUmlClass attributes select: [ :each | self checkIfMultiValue: each ].
	
	attributes do: [ :each | self decomposeAttribute: each ofClass: aMocoUmlClass ].
	
	aMocoUmlClass attributes removeAllSuchThat: [ :each | attributes anySatisfy: [ :a | a == each ] ].
	
	engine output guard: aMocoUmlClass with: #MocoMultiValueAttributeTransformationRule
]

{ #category : #transforming }
MocoUmlMultiValueAttributeTransformationRule >> execute [
	| classes |
	classes := engine output
		selectElementsOfKind: MocoUmlClass
		notGuarded: #MocoMultiValueAttributeTransformationRule.
	
	classes := classes select: [ :each | (engine detectInputElement: each) isNotNil ]. "isNotNil check ignores classes generated in this transformation phase"

	classes do: [ :each |
		self decomposeAttributesOn: each
	]
]

{ #category : #'private - processing' }
MocoUmlMultiValueAttributeTransformationRule >> generateAssociationFrom: aMocoUmlClass to: aMocoUmlClass2 forAttribute: aMocoUmlAttribute [
	"Creates an association to the new class for a multi-value attribute."
	
	| association source target |
	association := MocoUmlAssociation new.
	
	source := MocoUmlAssociationSide new.
	source element: aMocoUmlClass;
		name: (MocoNamingUtils toCamelCase: (aMocoUmlClass name)).
	source multiplicity lower value: 1.
	source multiplicity upper value: 1.
	
	target := MocoUmlAssociationSide new.
	target element: aMocoUmlClass2;
		name: (aMocoUmlAttribute name);
		visibility: (aMocoUmlAttribute visibility).
	target multiplicity lower value: (aMocoUmlAttribute multiplicity lower value).
	target multiplicity upper value: (aMocoUmlAttribute multiplicity upper value).
	
	aMocoUmlAttribute immutable ifTrue: [ target frozen: true ].
	
	association name: (MocoNamingUtils toCamelCase: ((aMocoUmlClass name) , ' ' , (aMocoUmlAttribute name)));
		source: source;
		target: target.
	
	^ association
]

{ #category : #'private - processing' }
MocoUmlMultiValueAttributeTransformationRule >> generateClassForAttribute: aMocoUmlAttribute ofClass: aMocoUmlClass [
	"Creates a new class that will store the values of the given attribute."
	
	| class attribute |
	class := MocoUmlClass new.
	
	class name: ((aMocoUmlClass name) , '_' , (MocoNamingUtils toFirstUpperCase: (aMocoUmlAttribute name))).
	
	attribute := MocoUmlAttribute new.
	
	attribute name: 'value';
		type: (aMocoUmlAttribute type);
		immutable: (aMocoUmlAttribute immutable).
		
	attribute multiplicity lower value: 1.
	attribute multiplicity upper value: 1.
	
	class attributes add: attribute.
	
	^ class
]

{ #category : #accessing }
MocoUmlMultiValueAttributeTransformationRule >> priority [
	^ 23
]
