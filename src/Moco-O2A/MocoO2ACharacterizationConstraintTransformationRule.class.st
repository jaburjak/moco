"
Generates Alloy facts based on Characterization relationships defined in an OntoUML model.
"
Class {
	#name : #MocoO2ACharacterizationConstraintTransformationRule,
	#superclass : #MocoO2ATransformationRule,
	#category : #'Moco-O2A-Rule'
}

{ #category : #transforming }
MocoO2ACharacterizationConstraintTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: MocoOntoUmlCharacterizationAssociation
		notGuarded: #MocoO2ACharacterizationConstraintTransformationRule.

	associations do: [ :each | self generateImmutabilityConstraintOf: each ].

	associations do: [ :each | engine input guard: each with: #MocoO2ACharacterizationConstraintTransformationRule ].

	associations ifEmpty: [ ^ self ].

	self generateAcyclicFact
]

{ #category : #'private - processing' }
MocoO2ACharacterizationConstraintTransformationRule >> findCharacterizations [
	^ (engine input elements select: [ :e | e isKindOf: MocoOntoUmlCharacterizationAssociation ]) collect: [ :e |
		{e. engine detectOutputElement: e ofKind: MocoAlloySignatureField} ]
]

{ #category : #'private - processing' }
MocoO2ACharacterizationConstraintTransformationRule >> findMoments [
	^ ((engine input elements select: [ :e | e isKindOf: MocoOntoUmlCharacterizationAssociation ]) flatCollect: [ :e |
		| m |
		m := OrderedCollection new.
		((e source element isKindOf: MocoOntoUmlMode) or: [ e source element isKindOf: MocoOntoUmlQuality ]) ifTrue: [ m add: (e source element) ].
		((e target element isKindOf: MocoOntoUmlMode) or: [ e target element isKindOf: MocoOntoUmlQuality ]) ifTrue: [ m add: (e target element) ].
		m
	]) collect: [ :e | engine detectOutputElement: e ofKind: MocoAlloySignatureField ]
]

{ #category : #'private - transforming' }
MocoO2ACharacterizationConstraintTransformationRule >> generateAcyclicFact [
	| relations moments fact |
	relations := self findCharacterizations.
	moments := self findMoments.

	relations ifEmpty: [ ^ self ].
	moments ifEmpty: [ ^ self ].
	
	relations := relations collect: [ :e |
		((e first source ordered) or: [ e first target ordered ])
			ifTrue: [ 'select13[w.' , (e second name) , ']' ]
			ifFalse: [ 'w.' , (e second name) ]
	].

	moments := moments collect: [ :e | 'w.' , (e name) ].

	fact := self findFact: 'acyclic'.

	self appendFact: fact with: ('all w: World | acyclic[' , ('+' join: relations) , ', ' , ('+' join: moments) , ']').

	engine output setModified
]

{ #category : #'private - transforming' }
MocoO2ACharacterizationConstraintTransformationRule >> generateImmutabilityConstraintOf: aMocoOntoUmlCharacterizationAssociation [
	| moment expr |
	moment := (aMocoOntoUmlCharacterizationAssociation source element).
	((moment isKindOf: MocoOntoUmlMode) or: [ moment isKindOf: MocoOntoUmlQuality ]) ifTrue: [ moment := aMocoOntoUmlCharacterizationAssociation target element ].

	(((aMocoOntoUmlCharacterizationAssociation source element) == moment) and: [ aMocoOntoUmlCharacterizationAssociation source frozen ]) ifTrue: [ ^ self ].
	(((aMocoOntoUmlCharacterizationAssociation target element) == moment) and: [ aMocoOntoUmlCharacterizationAssociation target frozen ]) ifTrue: [ ^ self ].

	expr := 'immutable_'.

	((aMocoOntoUmlCharacterizationAssociation source element) == moment)
		ifTrue: [ expr := expr , 'source' ] ifFalse: [ expr := expr , 'target' ].

	expr := expr , '[' , ((engine detectOutputElement: moment ofKind: MocoAlloySignatureField) name) , ', ' , ((engine detectOutputElement: aMocoOntoUmlCharacterizationAssociation ofKind: MocoAlloySignatureField) name) , ']'.

	self appendFact: (self findFact: 'associationProperties') with: expr.

	engine output setModified
]

{ #category : #accessing }
MocoO2ACharacterizationConstraintTransformationRule >> priority [
	^ 30
]
