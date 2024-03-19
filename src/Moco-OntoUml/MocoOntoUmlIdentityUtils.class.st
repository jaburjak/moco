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
	aMocoOntoUmlClass providesIdentity ifTrue: [ ^ true ].
	
	(aCollection select: [ :each | (each isKindOf: MocoOntoUmlGeneralization) and: [ (each subtype) == aMocoOntoUmlClass ] ])
		do: [ :each |
			(self checkIfHasIdentity: (each supertype) inModel: aCollection) ifTrue: [ ^ true ]
		].
	
	^ false
]
