"
Transforms part-whole relationships in an OntoUML model to an Alloy specification.
"
Class {
	#name : #MocoO2APartWholeRelationTransformationRule,
	#superclass : #MocoO2ARelationTransformationRule,
	#category : #'Moco-O2A-Rule'
}

{ #category : #transforming }
MocoO2APartWholeRelationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: MocoOntoUmlPartWholeAssociation
		notGuarded: #MocoO2APartWholeRelationTransformationRule.

	associations do: [ :each | self transformRelation: each ].

	associations do: [ :each |  engine input guard: each with: #MocoO2APartWholeRelationTransformationRule ]
]

{ #category : #'private - processing' }
MocoO2APartWholeRelationTransformationRule >> generateNonShareableFactFor: aMocoOntoUmlPartWholeAssociation withSide: aMocoOntoUmlAssociationSide [
	| wholeSide wholeFn fact otherWholes |
	wholeSide := aMocoOntoUmlPartWholeAssociation source.
	(wholeSide == aMocoOntoUmlAssociationSide) ifTrue: [ wholeSide := aMocoOntoUmlPartWholeAssociation target ].
	wholeFn := (self findEndFunctionFor: wholeSide ofRelation: aMocoOntoUmlPartWholeAssociation).

	fact := self findFact: 'nonShareable'.

	self appendFact: fact with: ('all w: World, x: w.' , ((self findClassFieldFor: (aMocoOntoUmlAssociationSide element)) name) , ' | lone ' , (wholeFn name) , '[x, w]').

	otherWholes := engine input elements select: [ :e |
		((e == aMocoOntoUmlPartWholeAssociation) not) and: [ (e isKindOf: MocoOntoUmlPartWholeAssociation) and: [ (e source shareability type isNotNil) or: [ e target shareability type isNotNil ] ] ] ].
	otherWholes := otherWholes collect: [ :e |
		e source shareability type ifNil: [ {e. e target} ] ifNotNil: [ {e. e source} ] ].
	otherWholes := otherWholes collect: [ :e | ((self findEndFunctionFor: (e second) ofRelation: (e first)) name) , '[x, w]' ].

	otherWholes ifNotEmpty: [
		| expr |
		expr := 'all w: World, x: w.' , ((self findClassFieldFor: (aMocoOntoUmlAssociationSide element)) name) , ' | some ' , (wholeFn name) , '[x, w] implies no '.
		((otherWholes size) > 1) ifTrue: [ expr := expr , '(' ].
		expr := expr , ('+' join: otherWholes).
		((otherWholes size) > 1) ifTrue: [ expr := expr , ')' ].
		self appendFact: fact with: expr
	] 
]

{ #category : #accessing }
MocoO2APartWholeRelationTransformationRule >> priority [
	^ 49
]

{ #category : #'private - transforming' }
MocoO2APartWholeRelationTransformationRule >> transformRelation: aMocoOntoUmlPartWholeAssociation [
	"basic transformation already performed by MocoO2ARelationTransformationRule"

	self generateAcyclicFactFor: aMocoOntoUmlPartWholeAssociation.

	aMocoOntoUmlPartWholeAssociation source shareability ifExclusive: [
		self generateNonShareableFactFor: aMocoOntoUmlPartWholeAssociation withSide: (aMocoOntoUmlPartWholeAssociation source)
	].

	aMocoOntoUmlPartWholeAssociation target shareability ifExclusive: [
		self generateNonShareableFactFor: aMocoOntoUmlPartWholeAssociation withSide: (aMocoOntoUmlPartWholeAssociation target)
	].
]
