"
Represents the type of an UML Class attribute.
"
Class {
	#name : #MocoUmlType,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #'instance creation' }
MocoUmlType class >> new [
	self error: 'Send newFromName: to create an instance.'
]

{ #category : #'instance creation' }
MocoUmlType class >> newFromName: aString [
	| inst |
	inst := self basicNew.
	
	inst name: aString.
	
	^ inst
]

{ #category : #accessing }
MocoUmlType >> name [
	^ name
]

{ #category : #'private - accessing' }
MocoUmlType >> name: aString [
	name := aString
]
