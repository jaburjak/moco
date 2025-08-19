"
Transforms Moco UML enumerations into an OpenPonk UML model.
"
Class {
	#name : 'MocoOpenPonkUmlEnumerationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-OpenPonk-Rule-Uml',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule-Uml'
}

{ #category : 'transforming' }
MocoOpenPonkUmlEnumerationTransformationRule >> execute [
	| enumerations |
	enumerations := engine input
		selectElementsOfKind: MocoUmlEnumeration
		notGuarded: #MocoOpenPonkUmlEnumerationTransformationRule.
	
	enumerations do: [ :each | self transformEnumeration: each ]
]

{ #category : 'accessing' }
MocoOpenPonkUmlEnumerationTransformationRule >> priority [
	^ 90
]

{ #category : 'private - transforming' }
MocoOpenPonkUmlEnumerationTransformationRule >> toOpenPonkLiteral: aMocoUmlEnumerationLiteral [
	"Returns the given enumeration literal as an OpenPonk model class."
	
	^ OPUMLEnumerationLiteral new
		name: (aMocoUmlEnumerationLiteral name);
		yourself
]

{ #category : 'private - transforming' }
MocoOpenPonkUmlEnumerationTransformationRule >> transformEnumeration: aMocoUmlEnumeration [
	"Transforms the given UML enumeration to the OpenPonk model."
	
	| op |
	op := OPUMLEnumeration new.
	
	op name: (aMocoUmlEnumeration name).
	
	op ownedLiterals addAll: (aMocoUmlEnumeration literals collect: [ :each | self toOpenPonkLiteral: each ]).
	
	engine addOutputElement: op withSource: aMocoUmlEnumeration.
	engine input guard: aMocoUmlEnumeration with: #MocoOpenPonkUmlEnumerationTransformationRule
]
