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
		'shareability'
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

{ #category : #initialization }
MocoOntoUmlAssociationSide >> initialize [
	multiplicity := MocoUmlMultiplicity new.
	name := ''.
	visibility := MocoUmlVisibility public.
	
	^ self
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> multiplicity [
	^ multiplicity
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> multiplicity: aMultiplicity [
	multiplicity := aMultiplicity
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOntoUmlAssociationSide >> printTo: aStream [
	visibility printTo: aStream.
	aStream nextPutAll: ' ' , name.
	element ifNotNil: [ aStream nextPutAll: ' : ' , element name ].
	aStream nextPutAll: ' '.
	multiplicity printTo: aStream.
	shareability ifShared: [ aStream nextPutAll: ' (shared)' ]; ifExclusive: [ aStream nextPutAll: ' (exclusive)' ].
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> shareability [
	^ shareability
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> shareability: aShareability [
	shareability := aShareability
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> visibility [
	^ visibility
]

{ #category : #accessing }
MocoOntoUmlAssociationSide >> visibility: aVisibility [
	visibility := aVisibility
]
