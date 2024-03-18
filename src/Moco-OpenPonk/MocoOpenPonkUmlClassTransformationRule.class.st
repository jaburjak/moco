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
	classes := engine inModel elements select: [ :each | (each isWrappingType: MocoUmlClass) and: [ each meta isNotProcessedBy: #MocoOpenPonkUmlClassTransformationRule ] ].
	
	classes do: [ :each |
		| class |
		class := self toOpenPonkClass: (each innerElement).
		class := MocoWrappedElement from: class.
		
		each meta outElements add: class.
		engine outModel elements add: class.
		
		each meta markProcessedBy: #MocoOpenPonkUmlClassTransformationRule
	].

	classes ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #accessing }
MocoOpenPonkUmlClassTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlClassTransformationRule >> toOpenPonkAttribute: aMocoUmlAttribute [
	| attr multiplicity |
	attr := OPUMLProperty new.
	
	attr name: (aMocoUmlAttribute name);
		visibility: (aMocoUmlAttribute visibility visibility);
		isReadOnly: (aMocoUmlAttribute immutable);
		isStatic: (aMocoUmlAttribute static).
	
	attr type: (OPUMLPrimitiveType new).
	attr type name: (aMocoUmlAttribute type name).
	
	multiplicity := MocoOpenPonkOntoUmlAttributeHelper toOpenPonkMultiplicity: (aMocoUmlAttribute multiplicity).
	attr lowerValue: (multiplicity first);
		upperValue: (multiplicity last).
		
	^ attr
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlClassTransformationRule >> toOpenPonkClass: aMocoUmlClass [
	| op |
	op := OPUMLClass new.
	
	op name: (aMocoUmlClass name);
		isAbstract: (aMocoUmlClass abstract).
	
	aMocoUmlClass attributes do: [ :each |
		| attr |
		attr := self toOpenPonkAttribute: each.
	
		op ownedAttributes add: attr
	].
		
	^ op
]
