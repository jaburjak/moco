"
Transformation engine for usage within tests.
"
Class {
	#name : #MocoTestTransformationEngine,
	#superclass : #MocoTransformationEngine,
	#instVars : [
		'choiceAnswer'
	],
	#category : #'Moco-Core-Tests-Engine'
}

{ #category : #accessing }
MocoTestTransformationEngine >> askChoice: aMocoChoiceBuilder [
	"Returns the predefined answer."
	
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
