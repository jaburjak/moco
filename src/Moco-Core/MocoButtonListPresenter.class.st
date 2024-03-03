"
Simple vertical sequence of buttons.
"
Class {
	#name : #MocoButtonListPresenter,
	#superclass : #SpPresenter,
	#category : #'Moco-Core-Ui'
}

{ #category : #layout }
MocoButtonListPresenter class >> defaultLayout [
	^ SpBoxLayout newTopToBottom
]

{ #category : #adding }
MocoButtonListPresenter >> add: aButton [
	self layout add: aButton
]
