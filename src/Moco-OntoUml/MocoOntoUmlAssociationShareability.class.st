"
Represents the shareability of an OntoUML association end.
"
Class {
	#name : #MocoOntoUmlAssociationShareability,
	#superclass : #Object,
	#instVars : [
		'type'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #'instance creation' }
MocoOntoUmlAssociationShareability class >> exclusive [
	| inst |
	inst := self new.
	
	inst type: #exclusive.
	
	^ inst
]

{ #category : #'instance creation' }
MocoOntoUmlAssociationShareability class >> shared [
	| inst |
	inst := self new.
	
	inst type: #shared.
	
	^ inst
]

{ #category : #testing }
MocoOntoUmlAssociationShareability >> ifExclusive: aBlock [
	(self isExclusive) ifTrue: aBlock
]

{ #category : #testing }
MocoOntoUmlAssociationShareability >> ifShared: aBlock [
	(self isShared) ifTrue: aBlock
]

{ #category : #accessing }
MocoOntoUmlAssociationShareability >> isExclusive [
	^ type = #exclusive
]

{ #category : #accessing }
MocoOntoUmlAssociationShareability >> isShared [
	^ type = #shared
]

{ #category : #printing }
MocoOntoUmlAssociationShareability >> printTo: aStream [
	self ifExclusive: [ aStream nextPutAll: 'exclusive' ];
		ifShared: [ aStream nextPutAll: 'shared' ].
]

{ #category : #'private - accessing' }
MocoOntoUmlAssociationShareability >> type [
	^ type
]

{ #category : #'private - accessing' }
MocoOntoUmlAssociationShareability >> type: aSymbol [
	aSymbol ifNotNil: [
		(#(shared exclusive) noneSatisfy: [ :each | each = aSymbol ]) ifTrue: [ self error: 'Invalid shareability type.' ]
	].

	type := aSymbol
]
