"
Transforms UML enumerations to Alloy enumerations.
"
Class {
	#name : 'MocoO2AEnumerationTransformationRule',
	#superclass : 'MocoO2ATransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoO2AEnumerationTransformationRule >> execute [
	| enums |
	enums := engine input
		selectElementsOfKind: MocoUmlEnumeration
		notGuarded: #MocoO2AEnumerationTransformationRule.
	
	enums do: [ :each | self transformEnumeration: each ].

	enums do: [ :each | engine input guard: each with: #MocoO2AEnumerationTransformationRule ]
]

{ #category : 'accessing' }
MocoO2AEnumerationTransformationRule >> priority [
	^ 101
]

{ #category : 'private - transforming' }
MocoO2AEnumerationTransformationRule >> transformEnumeration: aMocoUmlEnumeration [
	| enum |
	enum := MocoAlloyEnumeration new
		name: (self toAlloyName: (aMocoUmlEnumeration name) ifEmpty: 'Enumeration');
		yourself.

	aMocoUmlEnumeration literals do: [ :l | enum addLiteral: (MocoNamingUtils toPascalCase: (l name)) ].

	engine addOutputElement: enum withSource: aMocoUmlEnumeration
]
