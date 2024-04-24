Extension { #name : #MocoOntoUmlGeneralizationSet }

{ #category : #'*Moco-O2U' }
MocoOntoUmlGeneralizationSet >> subtypeCombinations [
	"Returns all combinations of subtypes based on the properties of the given generalization set."
	
	| combinations |
	combinations := OrderedCollection new.
	
	combinations addAll: ((members collect: [ :each | each subtype ]) sort: [ :a :b | (a name) < (b name) ]).
	
	disjoint
		ifTrue: [ combinations := combinations collect: [ :each | OrderedCollection with: each ] ]
		ifFalse: [ combinations := combinations combinations ].
	
	self ifNotCovering: [
		combinations := (OrderedCollection with: (OrderedCollection with: (members first supertype)))
			addAll: combinations;
			yourself
	].

	^ combinations
]
