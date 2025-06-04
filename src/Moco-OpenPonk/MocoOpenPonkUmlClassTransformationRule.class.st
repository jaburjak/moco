"
Transforms a UML Class from Moco’s model to OpenPonk’s model.
"
Class {
	#name : #MocoOpenPonkUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Uml'
}

{ #category : #transforming }
MocoOpenPonkUmlClassTransformationRule >> execute [
	| classes |
	classes := engine input
		selectElementsOfKind: MocoUmlClass
		notGuarded: #MocoOpenPonkUmlClassTransformationRule.
	
	classes do: [ :each | engine addOutputElement: (self toOpenPonkClass: each) withSource: each ].
	
	"Create all classes first, so resolveAttributeType: can link data types."
	
	classes do: [ :each |
		self toOpenPonkAttributes: each.
		
		engine input guard: each with: #MocoOpenPonkUmlClassTransformationRule
	]
]

{ #category : #accessing }
MocoOpenPonkUmlClassTransformationRule >> priority [
	^ 100
]

{ #category : #'private - processing' }
MocoOpenPonkUmlClassTransformationRule >> resolveAttributeType: aMocoUmlType [
	"Returns either an OPUMLPrimitiveType or an OPUMLClass representing the given data type."
	
	(aMocoUmlType isPrimitiveType)
		ifTrue: [ ^ OPUMLPrimitiveType new name: (aMocoUmlType name); yourself ].
	
	((engine output selectElementsOfKind: OPUMLClass) select: [ :each | (each name) = (aMocoUmlType name) ])
		do: [ :each | ^ each ].
	
	^ OPUMLClass new name: (aMocoUmlType name); yourself
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlClassTransformationRule >> toOpenPonkAttribute: aMocoUmlAttribute [
	"Creates an OpenPonk class attribute from the given Moco element."
	
	| attr multiplicity |
	attr := OPUMLProperty new.
	
	attr name: (aMocoUmlAttribute name);
		visibility: (aMocoUmlAttribute visibility visibility);
		isReadOnly: (aMocoUmlAttribute immutable);
		isStatic: (aMocoUmlAttribute static);
		isOrdered: (aMocoUmlAttribute ordered).
	
	aMocoUmlAttribute type ifNotNil: [
		attr type: (self resolveAttributeType: (aMocoUmlAttribute type))
	].
	
	multiplicity := MocoOpenPonkUmlAttributeTransformation toOpenPonkMultiplicity: (aMocoUmlAttribute multiplicity).
	attr lowerValue: (multiplicity first);
		upperValue: (multiplicity last).
		
	^ attr
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlClassTransformationRule >> toOpenPonkAttributes: aMocoUmlClass [
	"Adds attributes to the given class."
	
	| op |
	op := engine detectOutputElement: aMocoUmlClass.
	
	aMocoUmlClass attributes do: [ :each | op ownedAttributes add: (self toOpenPonkAttribute: each) ]
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlClassTransformationRule >> toOpenPonkClass: aMocoUmlClass [
	"Creates an empty OpenPonk class from the given Moco element."
	
	| op |
	op := OPUMLClass new.
	
	op name: (aMocoUmlClass name);
		isAbstract: (aMocoUmlClass abstract).
		
	^ op
]
