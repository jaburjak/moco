"
Represents source or target of a UML association.
"
Class {
	#name : #MocoUmlAssociationSide,
	#superclass : #Object,
	#instVars : [
		'element',
		'name',
		'visibility',
		'multiplicity',
		'aggregation',
		'frozen',
		'navigable',
		'ordered'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlAssociationSide >> aggregation [
	^ aggregation
]

{ #category : #accessing }
MocoUmlAssociationSide >> aggregation: anAggregation [
	anAggregation ifNil: [
		aggregation := MocoUmlAssociationAggregation new.
	] ifNotNil: [
		aggregation := anAggregation
	]
]

{ #category : #accessing }
MocoUmlAssociationSide >> element [
	^ element
]

{ #category : #accessing }
MocoUmlAssociationSide >> element: anObject [
	element := anObject
]

{ #category : #accessing }
MocoUmlAssociationSide >> frozen [
	^ frozen
]

{ #category : #accessing }
MocoUmlAssociationSide >> frozen: aBoolean [
	aBoolean ifNil: [
		frozen := false
	] ifNotNil: [
		frozen := aBoolean
	]
]

{ #category : #initialization }
MocoUmlAssociationSide >> initialize [
	super initialize.

	name := ''.
	multiplicity := MocoUmlMultiplicity new.
	visibility := MocoUmlVisibility public.
	aggregation := MocoUmlAssociationAggregation new.
	frozen := false.
	navigable := false.
	ordered := false
]

{ #category : #accessing }
MocoUmlAssociationSide >> multiplicity [
	^ multiplicity
]

{ #category : #accessing }
MocoUmlAssociationSide >> multiplicity: aMultiplicity [
	aMultiplicity ifNil: [
		multiplicity := MocoUmlMultiplicity new.
	] ifNotNil: [
		multiplicity := aMultiplicity
	]
]

{ #category : #accessing }
MocoUmlAssociationSide >> name [
	^ name
]

{ #category : #accessing }
MocoUmlAssociationSide >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #accessing }
MocoUmlAssociationSide >> navigable [
	^ navigable
]

{ #category : #accessing }
MocoUmlAssociationSide >> navigable: aBoolean [
	navigable := aBoolean ifNil: [ false ]
]

{ #category : #accessing }
MocoUmlAssociationSide >> ordered [
	^ ordered
]

{ #category : #accessing }
MocoUmlAssociationSide >> ordered: aBoolean [
	ordered := aBoolean
]

{ #category : #printing }
MocoUmlAssociationSide >> printTo: aStream [
	visibility printTo: aStream.
	aStream nextPutAll: ' ' , name.
	element ifNotNil: [ aStream nextPutAll: ' : ' , element name ].
	aStream nextPutAll: ' '.
	multiplicity printTo: aStream.
	aggregation ifShared: [ aStream nextPutAll: ' (shared)' ]; ifComposite: [ aStream nextPutAll: ' (composite)' ].
	frozen ifTrue: [ aStream nextPutAll: ' {frozen}' ].
	ordered ifTrue: [ aStream nextPutAll: ' {ordered}' ]
]

{ #category : #accessing }
MocoUmlAssociationSide >> visibility [
	^ visibility
]

{ #category : #accessing }
MocoUmlAssociationSide >> visibility: aVisibility [
	aVisibility ifNil: [
		visibility := MocoUmlVisibility public.
	] ifNotNil: [
		visibility := aVisibility
	]
]
