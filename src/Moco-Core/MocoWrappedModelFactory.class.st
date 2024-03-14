"
Factory class for creating instances of MocoWrappedModel from raw model elements.
"
Class {
	#name : #MocoWrappedModelFactory,
	#superclass : #Object,
	#category : #'Moco-Core-Utils'
}

{ #category : #'instance creation' }
MocoWrappedModelFactory class >> fromElements: aCollection [
	| model |
	model := MocoWrappedModel new.
	
	model elements addAll: (
		aCollection collect: [ :each | self wrapElement: each ]
	).
	
	^ model
]

{ #category : #'instance creation' }
MocoWrappedModelFactory class >> fromModel: aMocoWrappedModel [
	^ self fromElements: (aMocoWrappedModel elements)
]

{ #category : #'private - processing' }
MocoWrappedModelFactory class >> wrapElement: anObject [
	(anObject isKindOf: MocoWrappedElement)
		ifTrue: [ ^ self wrapElement: (anObject innerElement) ].
	
	^ MocoWrappedElement from: anObject
]
