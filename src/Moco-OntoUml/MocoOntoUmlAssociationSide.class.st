"
Represents one side of an OntoUML association.
"
Class {
	#name : #MocoOntoUmlAssociationSide,
	#superclass : #Object,
	#instVars : [
		'element',
		'name',
		'visibility',
		'multiplicity',
		'shareability',
		'frozen',
		'navigable',
		'ordered'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlAssociationSide >> element [
	^ element
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> element: anObject [
	element := anObject
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> frozen [
	^ frozen
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> frozen: aBoolean [
	frozen := aBoolean
]

{ #category : #initialization }
MocoOntoUmlAssociationSide >> initialize [
	super initialize.

	multiplicity := MocoUmlMultiplicity new.
	name := ''.
	visibility := MocoUmlVisibility public.
	shareability := MocoOntoUmlAssociationShareability new.
	frozen := false.
	navigable := false.
	ordered := false.
	
	^ self
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> multiplicity [
	^ multiplicity
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> multiplicity: aMultiplicity [
	aMultiplicity ifNil: [
		multiplicity := MocoUmlMultiplicity new.
	] ifNotNil: [
		multiplicity := aMultiplicity
	]
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> navigable [
	^ navigable
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> navigable: aBoolean [
	navigable := aBoolean ifNil: [ false ]
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> ordered [
	^ ordered
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> ordered: aBoolean [
	ordered := aBoolean
]

{ #category : #printing }
MocoOntoUmlAssociationSide >> printTo: aStream [
	visibility printTo: aStream.
	aStream nextPutAll: ' ' , name.
	element ifNotNil: [ aStream nextPutAll: ' : ' , element name ].
	aStream nextPutAll: ' '.
	multiplicity printTo: aStream.
	shareability ifShared: [ aStream nextPutAll: ' (shared)' ]; ifExclusive: [ aStream nextPutAll: ' (exclusive)' ].
	frozen ifTrue: [ aStream nextPutAll: ' {frozen}' ].
	ordered ifTrue: [ aStream nextPutAll: ' {ordered}' ]
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> shareability [
	^ shareability
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> shareability: aShareability [
	aShareability ifNil: [
		shareability := MocoOntoUmlAssociationShareability new.
	] ifNotNil: [
		shareability := aShareability
	]
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> visibility [
	^ visibility
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> visibility: aVisibility [
	aVisibility ifNil: [
		visibility := MocoUmlVisibility public.
	] ifNotNil: [
		visibility := aVisibility
	]
]
