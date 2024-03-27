"
Generates a unique name within a given context.
"
Class {
	#name : #MocoUniqueNameGenerator,
	#superclass : #Object,
	#category : #'Moco-Core-Utils'
}

{ #category : #accessing }
MocoUniqueNameGenerator class >> at: aBlock seed: aString [
	"Takes the given seed: and appends a number that will increment until at: returns false."
	
	| i current |
	i := 1.
	current := aString.
	
	[
		| exists |
		exists := aBlock value: current.
		
		exists
			ifTrue: [ i := i + 1. current := (aString , (i asString)) ]
			ifFalse: [ ^ current ].
		
		exists
	] whileTrue.

	^ current
]
