"
Presenter for a question with choices as clickable buttons.
"
Class {
	#name : #MocoChoicePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'questionText',
		'choiceLayout',
		'choice'
	],
	#category : #'Moco-Core-Ui'
}

{ #category : #specs }
MocoChoicePresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		add: #questionText;
		addLast: #choiceLayout;
		yourself
]

{ #category : #accessing }
MocoChoicePresenter >> addChoice: aString withId: anObject [
	| button |
	button := self instantiate: (SpButtonPresenter new).
	button label: aString;
		action: [
			self choice: anObject.
			self window close.
		].
	
	choiceLayout add: button.
]

{ #category : #accessing }
MocoChoicePresenter >> choice [
	^ choice
]

{ #category : #'private - accessing' }
MocoChoicePresenter >> choice: anObject [
	choice := anObject
]

{ #category : #initialization }
MocoChoicePresenter >> initializePresenters [
	questionText := self instantiate: (SpTextPresenter new).
	choiceLayout := self instantiate: (MocoButtonListPresenter new).
	
	questionText beNotEditable.
]

{ #category : #processing }
MocoChoicePresenter >> openAndWait [
	self open.
	
	self centered.

	MorphicRenderLoop new doOneCycleWhile: [ self adapter widget isInWorld ].
	
	^ choice
]

{ #category : #accessing }
MocoChoicePresenter >> question: aString [
	questionText text: aString
]

{ #category : #accessing }
MocoChoicePresenter >> title [
	^ 'Choose Transformation Option'
]
