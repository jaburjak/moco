"
Contains utilities for transforming generalization sets.
"
Class {
	#name : #MocoOntoUmlGeneralizationSetTransformation,
	#superclass : #Object,
	#category : #'Moco-O2U-Transformation'
}

{ #category : #processing }
MocoOntoUmlGeneralizationSetTransformation class >> generateInstanceCombinations: aMocoOntoUmlGeneralizationSet [
	"Returns all instance combinations based on the properties of the given generalization set."
	
	| combinations |
	combinations := OrderedCollection new.
	
	combinations addAll: ((aMocoOntoUmlGeneralizationSet members collect: [ :each | each subtype ]) sort: [ :a :b | (a name) < (b name) ]).
	
	(aMocoOntoUmlGeneralizationSet disjoint)
		ifTrue: [ combinations := combinations collect: [ :each | OrderedCollection with: each ] ]
		ifFalse: [ combinations := combinations combinations ].
	
	aMocoOntoUmlGeneralizationSet ifNotCovering: [
		combinations := (OrderedCollection with: (OrderedCollection with: (aMocoOntoUmlGeneralizationSet members first supertype)))
			addAll: combinations;
			yourself
	].

	^ combinations
]
