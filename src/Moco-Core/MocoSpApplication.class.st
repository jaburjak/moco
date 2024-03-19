"
Spec2 application class for Moco user interface.
"
Class {
	#name : #MocoSpApplication,
	#superclass : #SpApplication,
	#classVars : [
		'instance'
	],
	#category : #'Moco-Core-Ui'
}

{ #category : #activation }
MocoSpApplication class >> applicationName [
	^ 'Moco'
]

{ #category : #accessing }
MocoSpApplication class >> instance [
	instance ifNil: [
		instance := self new
	].

	^ instance
]
