"
Presenter for displaying the transcript of model transformations.
"
Class {
	#name : #MocoTranscriptPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tabs',
		'saveButton',
		'body'
	],
	#category : #'Moco-Core-Ui'
}

{ #category : #layout }
MocoTranscriptPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
		spacing: 6;
		add: (SpBoxLayout newLeftToRight add: #tabs; add: #saveButton expand: false; yourself) expand: false;
		add: #body;
		yourself
]

{ #category : #adding }
MocoTranscriptPresenter >> addSection: aString withLabel: aString2 [
	| button |
	button := self newButton.
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

{ #category : #'private - accessing' }
MocoTranscriptPresenter >> focusedSection [
	"Returns the name of the currently open transcript section."
	
	| button |
	button := tabs layout children detect: [ :each | each state ] ifNone: [ ^ nil ].
	
	^ button label
]

{ #category : #initialization }
MocoTranscriptPresenter >> initializePresenters [
	tabs := self instantiate: (MocoButtonListPresenter new).
	tabs layout: (SpBoxLayout newLeftToRight hAlignStart; yourself).
	
	saveButton := self newButton.
	saveButton icon: (self iconNamed: #smallSaveAs);
		label: 'Save as...';
		action: [ self saveTranscript ].
	
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
	
	aWindowPresenter title: 'Transformation Transcript';
		aboutText: 'Contains the transcript of the performed transformations.';
		windowIcon: (MocoIcons mocoIcon);
		initialExtent: 800@500
]

{ #category : #accessing }
MocoTranscriptPresenter >> saveButton [
	^ saveButton
]

{ #category : #'private - processing' }
MocoTranscriptPresenter >> saveTranscript [
	| file |
	file := StFBSaveFileDialog new
		title: 'Save Transformation Transcript'.
	
	(self focusedSection includesSubstring: 'SQL')
		ifTrue: [ file extensions: #(sql) named: 'SQL file' ]
		ifFalse: [ file extensions: #(txt) named: 'Plain text file' ].
	
	file := file openModal.
	
	file ifNil: [ ^ self ].
	
	file asFileReference writeStreamDo: [ :stream | stream << (body text withInternetLineEndings) ].
	
	UIManager default
		inform: 'Transcript saved to ' , file pathString
]

{ #category : #accessing }
MocoTranscriptPresenter >> tabs [
	^ tabs
]
