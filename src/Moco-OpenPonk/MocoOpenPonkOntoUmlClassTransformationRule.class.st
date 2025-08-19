"
Transforms an OpenPonk OntoUML class into its Moco counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlClassTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlClassTransformationRule class >> modelClass [
	^ MocoOntoUmlClass
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlClassTransformationRule class >> stereotypeSelector [
	^ nil
]

{ #category : 'transforming' }
MocoOpenPonkOntoUmlClassTransformationRule >> execute [
	| classes |
	classes := engine input
		selectElementsOfKind: OPUMLClass
		ofStereotype: (self class stereotypeSelector ifNil: [ nil ] ifNotNil: [ self class stereotypeSelector asString ])
		notGuarded: #MocoOpenPonkOntoUmlClassTransformationRule.
	
	classes do: [ :each |
		| class |
		class := self transformClass: each.
		
		engine addOutputElement: class withSource: each.
		engine input guard: each with: #MocoOpenPonkOntoUmlClassTransformationRule
	]
]

{ #category : 'accessing' }
MocoOpenPonkOntoUmlClassTransformationRule >> priority [
	^ 100
]

{ #category : 'private - transforming' }
MocoOpenPonkOntoUmlClassTransformationRule >> transformAttribute: anOPUMLAttribute [
	"Transforms OpenPonk class attribute to a Moco class attribute."
	
	| attr |
	attr := MocoOntoUmlAttribute new.
	
	attr name: anOPUMLAttribute name.
	attr visibility visibility: ((MocoOpenPonkUmlAttributeTransformation toMocoVisibility: (anOPUMLAttribute visibility)) visibility).
	attr static: anOPUMLAttribute isStatic.
	attr immutable: anOPUMLAttribute isReadOnly.
	attr ordered: anOPUMLAttribute isOrdered.
	attr multiplicity lower: (MocoUmlMultiplicityBound value: ((anOPUMLAttribute lowerValue) ifNil: [ 1 ] ifNotNil: [ anOPUMLAttribute lowerValue value ])).
	attr multiplicity upper: (MocoUmlMultiplicityBound value: ((anOPUMLAttribute upperValue) ifNil: [ 1 ] ifNotNil: [ anOPUMLAttribute upperValue value ])).
	anOPUMLAttribute type ifNotNil: [ attr type: (MocoUmlType newFromName: (anOPUMLAttribute type name)) ].
		
	^ attr
]

{ #category : 'private - transforming' }
MocoOpenPonkOntoUmlClassTransformationRule >> transformAttributes: anOPUMLClass [
	"Returns attributes of the given OpenPonk UML class a Moco attributes."
	
	^ (anOPUMLClass ownedAttributes select: [ :each | each association isNil ])
		collect: [ :each | self transformAttribute: each ]
]

{ #category : 'private - transforming' }
MocoOpenPonkOntoUmlClassTransformationRule >> transformClass: anOPUMLClass [
	"Transforms an OpenPonk OntoUML class into a Moco OntoUML class."
	
	| class |
	class := (self class modelClass) new.
	
	class name: (anOPUMLClass name);
		abstract: (anOPUMLClass isAbstract).
	
	class attributes addAll: (self transformAttributes: anOPUMLClass).
	
	^ class
]
