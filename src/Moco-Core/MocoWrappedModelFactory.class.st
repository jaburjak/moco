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
		aCollection collect: [ :each | self wrapElement: each retainMetaProperties: #() ]
	).
	
	^ model
]

{ #category : #'instance creation' }
MocoWrappedModelFactory class >> fromElements: aCollection retainMetaProperties: aCollection2 [
	| model |
	model := MocoWrappedModel new.
	
	model elements addAll: (
		aCollection collect: [ :each | self wrapElement: each retainMetaProperties: aCollection2 ]
	).
	
	^ model
]

{ #category : #'instance creation' }
MocoWrappedModelFactory class >> fromModel: aMocoWrappedModel [
	^ self fromElements: (aMocoWrappedModel elements)
]

{ #category : #'instance creation' }
MocoWrappedModelFactory class >> fromModel: aMocoWrappedModel retainMetaProperties: aCollection2 [
	^ self fromElements: (aMocoWrappedModel elements) retainMetaProperties: aCollection2
]

{ #category : #'private - processing' }
MocoWrappedModelFactory class >> wrapElement: anObject retainMetaProperties: aCollection [
	(anObject isKindOf: MocoWrappedElement)
		ifTrue: [
			| wrapped |
			wrapped := MocoWrappedElement from: (anObject innerElement).
			
			aCollection do: [ :each |
				| prop |
				prop := anObject meta at: each.
				
				prop ifNotNil: [ wrapped meta at: each put: prop ]
			].
		
			^ wrapped
		].
	
	^ MocoWrappedElement from: anObject
]
