"
Transforms enumerations from the OpenPonk model to the Moco model.
"
Class {
	#name : 'MocoOpenPonkOntoUmlEnumerationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoOpenPonkOntoUmlEnumerationTransformationRule >> execute [
	| enumerations |
	enumerations := engine input
		selectElementsOfKind: OPUMLEnumeration
		notGuarded: #MocoOpenPonkOntoUmlEnumerationTransformationRule.
	
	enumerations do: [ :each | self transformEnumeration: each ]
]

{ #category : 'accessing' }
MocoOpenPonkOntoUmlEnumerationTransformationRule >> priority [
	^ 80
]

{ #category : 'private - transforming' }
MocoOpenPonkOntoUmlEnumerationTransformationRule >> toMocoLiteral: anOPUMLEnumerationLiteral [
	"Returns the given OpenPonk enumeration literal as an instance of MocoEnumerationLiteral."
	
	^ MocoUmlEnumerationLiteral new
		name: (anOPUMLEnumerationLiteral name);
		yourself
]

{ #category : 'private - transforming' }
MocoOpenPonkOntoUmlEnumerationTransformationRule >> transformEnumeration: anOPUMLEnumeration [
	"Transforms the given OpenPonk UML enumeration to the Moco model."
	
	| enumeration |
	enumeration := MocoUmlEnumeration new.
	
	enumeration name: (anOPUMLEnumeration name).
	enumeration literals addAll: (anOPUMLEnumeration ownedLiterals collect: [ :each | self toMocoLiteral: each ]).
	
	engine addOutputElement: enumeration withSource: anOPUMLEnumeration.
	engine input guard: anOPUMLEnumeration with: #MocoOpenPonkOntoUmlEnumerationTransformationRule
]
