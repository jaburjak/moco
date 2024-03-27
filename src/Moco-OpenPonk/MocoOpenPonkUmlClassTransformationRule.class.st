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
	
	classes do: [ :each |
		| class |
		class := self toOpenPonkClass: each.
		
		engine addOutputElement: class withSource: each.
		
		engine input guard: each with: #MocoOpenPonkUmlClassTransformationRule
	]
]

{ #category : #accessing }
MocoOpenPonkUmlClassTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlClassTransformationRule >> toOpenPonkAttribute: aMocoUmlAttribute [
	"Creates an OpenPonk class attribute from the given Moco element."
	
	| attr multiplicity |
	attr := OPUMLProperty new.
	
	attr name: (aMocoUmlAttribute name);
		visibility: (aMocoUmlAttribute visibility visibility);
		isReadOnly: (aMocoUmlAttribute immutable);
		isStatic: (aMocoUmlAttribute static).
	
	aMocoUmlAttribute type ifNotNil: [
		attr type: (OPUMLPrimitiveType new).
		attr type name: (aMocoUmlAttribute type name)
	].
	
	multiplicity := MocoOpenPonkUmlAttributeTransformation toOpenPonkMultiplicity: (aMocoUmlAttribute multiplicity).
	attr lowerValue: (multiplicity first);
		upperValue: (multiplicity last).
		
	^ attr
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlClassTransformationRule >> toOpenPonkClass: aMocoUmlClass [
	"Creates an OpenPonk class from the given Moco element."
	
	| op |
	op := OPUMLClass new.
	
	op name: (aMocoUmlClass name);
		isAbstract: (aMocoUmlClass abstract).
	
	aMocoUmlClass attributes do: [ :each | op ownedAttributes add: (self toOpenPonkAttribute: each) ].
		
	^ op
]
