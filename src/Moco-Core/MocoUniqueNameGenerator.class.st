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
	
	^ self at: aBlock seed: aString format: [ :s :i | s , (i asString) ]
]

{ #category : #accessing }
MocoUniqueNameGenerator class >> at: aBlock seed: aString format: aBlock2 [
	"Takes the given seed: and returns the result of the given format: block evaluated with a number that will increment until at: returns false.
	 The format: block takes two argument - first is the seed, second is the counter."
	
	| i current |
	i := 1.
	current := aString.
	
	[
		| exists |
		exists := aBlock value: current.
		
		exists
			ifTrue: [ i := i + 1. current := aBlock2 value: aString value: i ]
			ifFalse: [ ^ current ].
		
		exists
	] whileTrue.

	^ current
]
