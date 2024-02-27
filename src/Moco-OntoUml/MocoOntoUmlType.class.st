"
Represents an OntoUML attribute type.
"
Class {
	#name : #MocoOntoUmlType,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #'instance creation' }
MocoOntoUmlType class >> new [
	self error: 'Send newFromName: to create an instance.'
]

{ #category : #'instance creation' }
MocoOntoUmlType class >> newFromName: aString [
	| inst |
	inst := self basicNew.
	
	inst name: aString.
	
	^ inst
]

{ #category : #accessing }
MocoOntoUmlType >> name [
	^ name
]

{ #category : #'private - accessing' }
MocoOntoUmlType >> name: aString [
	name := aString 
]
