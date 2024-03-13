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
	^ (aMocoUmlAttribute multiplicity upper isUnbounded or: [ aMocoUmlAttribute multiplicity upper value > 1 ])
]

{ #category : #'private - processing' }
MocoUmlMultiValueAttributeTransformationRule >> decomposeAttribute: aMocoUmlAttribute ofClass: aMocoWrappedElement [
	| inElement class classOut association associationOut |
	class := self generateClassForAttribute: aMocoUmlAttribute ofClass: (aMocoWrappedElement innerElement).
	association := self generateAssociationFrom: aMocoWrappedElement to: class forAttribute: aMocoUmlAttribute.
	
	classOut := MocoWrappedElement from: class.
	associationOut := MocoWrappedElement from: association.
	
	inElement := engine findInElementFor: aMocoWrappedElement.
	
	inElement meta outElements add: classOut.
	inElement meta outElements add: associationOut.
	
	engine outModel elements add: classOut.
	engine outModel elements add: associationOut
]

{ #category : #'private - transforming' }
MocoUmlMultiValueAttributeTransformationRule >> decomposeAttributesOn: aMocoWrappedElement [
	| attributes |
	attributes := aMocoWrappedElement innerElement attributes select: [ :each | self checkIfMultiValue: each ].

	attributes do: [ :each | self decomposeAttribute: each ofClass: aMocoWrappedElement ].
	
	attributes ifNotEmpty: [ engine outModel meta didChange: true ].
	
	aMocoWrappedElement innerElement attributes removeAllSuchThat: [ :each | attributes anySatisfy: [ :a | a == each ] ].

	aMocoWrappedElement meta markProcessedBy: #MocoMultiValueAttributeTransformationRule
]

{ #category : #transforming }
MocoUmlMultiValueAttributeTransformationRule >> execute [
	| classes |
	classes := engine outModel elements select: [ :each |
		(each isWrappingType: MocoUmlClass) and: [ ((engine findInElementFor: each) meta isProcessedBy: #MocoUmlMultiValueAttributeTransformationRule) not ] 
	].

	classes do: [ :each |
		self decomposeAttributesOn: each
	]
]

{ #category : #'private - processing' }
MocoUmlMultiValueAttributeTransformationRule >> generateAssociationFrom: aMocoWrappedElement to: aMocoUmlClass forAttribute: aMocoUmlAttribute [
	| association source target |
	association := MocoUmlAssociation new.
	
	source := MocoUmlAssociationSide new.
	source element: (aMocoWrappedElement innerElement);
		name: (MocoNamingUtils toCamelCase: (aMocoWrappedElement innerElement name)).
	source multiplicity lower value: 1.
	source multiplicity upper value: 1.
	
	target := MocoUmlAssociationSide new.
	target element: aMocoUmlClass;
		name: (aMocoUmlAttribute name);
		visibility: (aMocoUmlAttribute visibility).
	target multiplicity lower value: (aMocoUmlAttribute multiplicity lower value).
	target multiplicity upper value: (aMocoUmlAttribute multiplicity upper value).
	
	association name: (MocoNamingUtils toCamelCase: ((aMocoWrappedElement innerElement name) , ' ' , (aMocoUmlAttribute name)));
		source: source;
		target: target.
	
	^ association
]

{ #category : #'private - processing' }
MocoUmlMultiValueAttributeTransformationRule >> generateClassForAttribute: aMocoUmlAttribute ofClass: aMocoUmlClass [
	| class attribute |
	class := MocoUmlClass new.
	
	class name: ((aMocoUmlClass name) , '_' , (MocoNamingUtils toFirstUpperCase: (aMocoUmlAttribute name))).
	
	attribute := MocoUmlAttribute new.
	
	attribute name: (aMocoUmlAttribute name);
		type: (aMocoUmlAttribute type).
		
	attribute multiplicity lower value: 1.
	attribute multiplicity upper value: 1.
	
	class attributes add: attribute.
	
	^ class
]

{ #category : #accessing }
MocoUmlMultiValueAttributeTransformationRule >> priority [
	^ 20
]
