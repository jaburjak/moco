"
Transformation engine for usage within tests.
"
Class {
	#name : #MocoTestTransformationEngine,
	#superclass : #MocoTransformationEngine,
	#instVars : [
		'choiceAnswer',
		'choices'
	],
	#category : #'Moco-Core-Tests-Engine'
}

{ #category : #accessing }
MocoTestTransformationEngine >> askChoice: aMocoChoiceBuilder [
	"Returns the predefined answer."
	
	choices addAll: (aMocoChoiceBuilder choices collect: [ :each | each id ]).
	
	choiceAnswer ifNil: [ ^ self error: 'Missing answer.' ].
	
	^ choiceAnswer
]

{ #category : #accessing }
MocoTestTransformationEngine >> choiceAnswer [
	^ choiceAnswer
]

{ #category : #accessing }
MocoTestTransformationEngine >> choiceAnswer: aSymbol [
	choiceAnswer := aSymbol
]

{ #category : #accessing }
MocoTestTransformationEngine >> choices [
	"Returns all transformation option choices declared by the executed rules."
	
	^ choices
]

{ #category : #initialization }
MocoTestTransformationEngine >> initialize [
	super initialize.
	
	choices := OrderedCollection new
]
