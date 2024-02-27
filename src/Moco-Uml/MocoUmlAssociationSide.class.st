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
		'frozen'
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

{ #category : #printing }
MocoUmlAssociationSide >> printTo: aStream [
	visibility printTo: aStream.
	aStream nextPutAll: ' ' , name.
	element ifNotNil: [ aStream nextPutAll: ' : ' , element name ].
	aStream nextPutAll: ' '.
	multiplicity printTo: aStream.
	aggregation ifShared: [ aStream nextPutAll: ' (shared)' ]; ifComposite: [ aStream nextPutAll: ' (composite)' ].
	frozen ifTrue: [ aStream nextPutAll: ' {frozen}' ].
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
