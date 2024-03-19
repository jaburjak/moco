"
Presenter for displaying the transcript of model transformations.
"
Class {
	#name : #MocoTranscriptPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tabs',
		'body'
	],
	#category : #'Moco-Core-Ui'
}

{ #category : #layout }
MocoTranscriptPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		spacing: 6;
		add: #tabs expand: false;
		add: #body;
		yourself
]

{ #category : #adding }
MocoTranscriptPresenter >> addSection: aString withLabel: aString2 [
	| button |
	button := self instantiate: (SpButtonPresenter new).
	button label: aString2;
		action: [
			tabs layout children do: [ :each | each state: false ].
			button state: true.
			body text: aString
		].
	
	tabs add: button
]

{ #category : #accessing }
MocoTranscriptPresenter >> body [
	^ body
]

{ #category : #initialization }
MocoTranscriptPresenter >> initializePresenters [
	tabs := self instantiate: (MocoButtonListPresenter new).
	tabs layout: (SpBoxLayout newLeftToRight hAlignStart; yourself).
	
	body := self instantiate: (SpCodePresenter new).
	body syntaxHighlight: false;
		overrideContextMenu: true;
		contextMenu: [
			(SpTextPresenter buildEditionCommandsGroupFor: body) asMenuPresenter
		]
]

{ #category : #initialization }
MocoTranscriptPresenter >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	
	aWindowPresenter title: 'Transformation Result';
		aboutText: 'Contains the transcript of the performed transformations.';
		windowIcon: (MocoIcons mocoIcon)
]

{ #category : #accessing }
MocoTranscriptPresenter >> tabs [
	^ tabs
]
