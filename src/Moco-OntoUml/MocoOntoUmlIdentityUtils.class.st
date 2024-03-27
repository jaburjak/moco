"
Utility class for checking OntoUML class identity.
"
Class {
	#name : #MocoOntoUmlIdentityUtils,
	#superclass : #Object,
	#category : #'Moco-OntoUml-Utils'
}

{ #category : #testing }
MocoOntoUmlIdentityUtils class >> checkIfHasIdentity: aMocoOntoUmlClass inModel: aCollection [
	"Returns true if the given OntoUML class has an identity provided by either itself or by its supertype in the given model."
	
	aMocoOntoUmlClass providesIdentity ifTrue: [ ^ true ].
	
	^ (aCollection select: [ :each | (each isKindOf: MocoOntoUmlGeneralization) and: [ (each subtype) == aMocoOntoUmlClass ] ])
		anySatisfy: [ :each |
			(self checkIfHasIdentity: (each supertype) inModel: aCollection)
		]
]
