"
Container for transformation alternatives.
"
Class {
	#name : #MocoChoiceBuilder,
	#superclass : #Object,
	#instVars : [
		'question',
		'choices'
	],
	#category : #'Moco-Core-Engine'
}

{ #category : #accessing }
MocoChoiceBuilder >> addChoice: aString withId: anObject [
	| choice |
	choice := MocoChoice new.
	choice label: aString;
		id: anObject.
		
	choices add: choice.
	
	^ choice
]

{ #category : #accessing }
MocoChoiceBuilder >> choices [
	^ choices
]

{ #category : #initialization }
MocoChoiceBuilder >> initialize [
	question := 'Please choose how the transformation should proceed.'.
	choices := OrderedCollection new.
]

{ #category : #accessing }
MocoChoiceBuilder >> question [
	^ question
]

{ #category : #accessing }
MocoChoiceBuilder >> question: aString [
	question := aString
]
