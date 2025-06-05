"
Generates Alloy facts based on the Relator universals in an OntoUML model.
"
Class {
	#name : 'MocoO2ARelatorConstraintTransformationRule',
	#superclass : 'MocoO2ATransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoO2ARelatorConstraintTransformationRule >> execute [
	| classes |
	classes := engine input
		selectElementsOfKind: MocoOntoUmlRelator
		notGuarded: #MocoO2ARelatorConstraintTransformationRule.
	
	classes do: [ :each | self generateRelatorConstraintOf: each ].

	classes do: [ :each |  engine input guard: each with: #MocoO2ARelatorConstraintTransformationRule ]
]

{ #category : 'private - processing' }
MocoO2ARelatorConstraintTransformationRule >> findClassFieldFor: aMocoOntoUmlClass [
	^ engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField
]

{ #category : 'private - processing' }
MocoO2ARelatorConstraintTransformationRule >> findEndFunctionOpposite: aMocoOntoUmlAssociationSide ofRelation: aMocoOntoUmlAssociation [
	| fns |
	fns := engine selectOutputElements: aMocoOntoUmlAssociation ofKind: MocoAlloyFunction.

	((aMocoOntoUmlAssociation source element) == aMocoOntoUmlAssociationSide) ifFalse: [ ^ fns first ].

	((aMocoOntoUmlAssociation target element) == aMocoOntoUmlAssociationSide) ifFalse: [ ^ fns second ].

	^ nil
]

{ #category : 'private - processing' }
MocoO2ARelatorConstraintTransformationRule >> findMediationRelationsOf: aMocoOntoUmlRelator [
	^ engine input elements select: [ :e | (e isKindOf: MocoOntoUmlMediationAssociation) and: [
			((e source element) == aMocoOntoUmlRelator) or: [ (e target element) == aMocoOntoUmlRelator ] ] ]
]

{ #category : 'private - transforming' }
MocoO2ARelatorConstraintTransformationRule >> generateImmutabilityConstraintOf: aMocoOntoUmlRelator [
	| mediations fact name |
	mediations := self findMediationRelationsOf: aMocoOntoUmlRelator.

	mediations ifEmpty: [ ^ self ].

	fact := self findFact: 'associationProperties'.
	
	name := (self findClassFieldFor: aMocoOntoUmlRelator) name.

	mediations do: [ :e |
		| n |
		n := (engine detectOutputElement: e ofKind: MocoAlloySignatureField) name.

		((e source element) == aMocoOntoUmlRelator) ifTrue: [
			(e source frozen) ifFalse: [
				self appendFact: fact with: ('immutable_source[' , name, ', ' , n , ']').
				engine output setModified
			]
		].

		((e target element) == aMocoOntoUmlRelator) ifTrue: [
			(e target frozen) ifFalse: [
				self appendFact: fact with: ('immutable_target[' , name, ', ' , n , ']').
				engine output setModified
			]
		]
	]
]

{ #category : 'private - transforming' }
MocoO2ARelatorConstraintTransformationRule >> generateRelatorConstraintOf: aMocoOntoUmlRelator [
	| relations fact |
	relations := self findMediationRelationsOf: aMocoOntoUmlRelator.

	((relations size) < 2) ifTrue: [ ^ self ].

	fact := self findFact: 'relatorConstraint'.

	relations := relations collect: [ :e | (self findEndFunctionOpposite: aMocoOntoUmlRelator ofRelation: e) ].
	relations := relations collect: [ :e | (e name) , '[x, w]' ].

	self appendFact: fact with: ('all w: World, x: w.' , ((self findClassFieldFor: aMocoOntoUmlRelator) name) , ' | #(' , ('+' join: relations) , ') >= 2').

	self generateImmutabilityConstraintOf: aMocoOntoUmlRelator
]

{ #category : 'accessing' }
MocoO2ARelatorConstraintTransformationRule >> priority [
	^ 30
]
