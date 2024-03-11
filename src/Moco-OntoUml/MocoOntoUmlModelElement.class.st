"
Base class of a OntoUML model element.
"
Class {
	#name : #MocoOntoUmlModelElement,
	#superclass : #Object,
	#category : #'Moco-OntoUml-Model'
}

{ #category : #'instance creation' }
MocoOntoUmlModelElement class >> new [
	(self asString = 'MocoOntoUmlModelElement') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]
