"
Generates Alloy facts based on part-whole structures in an OntoUML model.
"
Class {
	#name : 'MocoO2AWholeConstraintTransformationRule',
	#superclass : 'MocoO2ATransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoO2AWholeConstraintTransformationRule >> execute [
	| classes |
	classes := engine input
		selectElementsOfKind: MocoOntoUmlClass
		notGuarded: #MocoO2AWholeConstraintTransformationRule.
	
	classes do: [ :each | self generateWeakSupplementationConstraintOf: each ].

	classes do: [ :each | engine input guard: each with: #MocoO2AWholeConstraintTransformationRule ]
]

{ #category : 'private - processing' }
MocoO2AWholeConstraintTransformationRule >> findEndFunctionFor: aMocoOntoUmlAssociationSide ofRelation: aMocoOntoUmlAssociation [
	| fns |
	fns := engine selectOutputElements: aMocoOntoUmlAssociation ofKind: MocoAlloyFunction.

	((aMocoOntoUmlAssociation source) == aMocoOntoUmlAssociationSide) ifTrue: [ ^ fns first ].

	((aMocoOntoUmlAssociation target) == aMocoOntoUmlAssociationSide) ifTrue: [ ^ fns second ].

	^ nil
]

{ #category : 'private - transforming' }
MocoO2AWholeConstraintTransformationRule >> generateWeakSupplementationConstraintOf: aMocoOntoUmlClass [
	| relations parts expr |
	relations := engine input elements select: [ :e | (e isKindOf: MocoOntoUmlPartWholeAssociation) and: [
		(((e source element) == aMocoOntoUmlClass) and: [ e target shareability type isNotNil ])
		or: [ ((e target element) == aMocoOntoUmlClass) and: [ e source shareability type isNotNil ] ] ] ].

	relations ifEmpty: [ ^ self ].

	parts := relations collect: [ :e |
		(e source element == aMocoOntoUmlClass)
			ifTrue: [ { e. e target } ]
			ifFalse: [ { e. e source } ]
	].

	parts := parts collect: [ :e | ((self findEndFunctionFor: (e second) ofRelation: (e first)) name) , '[x, w]' ].

	expr := 'all w: World, x: w.' , ((engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField) name) , ' | #'.

	((relations size) > 1) ifTrue: [ expr := expr , '(' ].

	expr := expr , ('+' join: parts).

	((relations size) > 1) ifTrue: [ expr := expr , ')' ].

	expr := expr , ' >= 2'.

	self appendFact: (self findFact: 'weakSupplementationConstraint') with: expr.

	engine output setModified
]

{ #category : 'accessing' }
MocoO2AWholeConstraintTransformationRule >> priority [
	^ 30
]
