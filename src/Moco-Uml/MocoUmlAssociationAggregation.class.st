"
Represents the aggregation type of a UML association.
"
Class {
	#name : #MocoUmlAssociationAggregation,
	#superclass : #Object,
	#instVars : [
		'type'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #'accessing - enum' }
MocoUmlAssociationAggregation class >> composite [
	| inst |
	inst := self new.
	
	inst type: #composite.
	
	^ inst
]

{ #category : #'accessing - enum' }
MocoUmlAssociationAggregation class >> shared [
	| inst |
	inst := self new.
	
	inst type: #shared.
	
	^ inst
]

{ #category : #testing }
MocoUmlAssociationAggregation >> ifComposite: aBlock [
	(self isComposite) ifTrue: aBlock
]

{ #category : #testing }
MocoUmlAssociationAggregation >> ifShared: aBlock [
	(self isShared) ifTrue: aBlock
]

{ #category : #accessing }
MocoUmlAssociationAggregation >> isComposite [
	^ type = #composite
]

{ #category : #accessing }
MocoUmlAssociationAggregation >> isShared [
	^ type = #shared
]

{ #category : #printing }
MocoUmlAssociationAggregation >> printTo: aStream [
	self ifComposite: [ aStream nextPutAll: 'composite' ];
		ifShared: [ aStream nextPutAll: 'shared' ].
]

{ #category : #'private - accessing' }
MocoUmlAssociationAggregation >> type [
	^ type
]

{ #category : #'private - accessing' }
MocoUmlAssociationAggregation >> type: aSymbol [
	aSymbol ifNotNil: [
		(#(shared composite) noneSatisfy: [ :each | each = aSymbol ]) ifTrue: [ self error: 'Invalid aggregation type.' ]
	].

	type := aSymbol
]
