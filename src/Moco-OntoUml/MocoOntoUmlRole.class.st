"
Represents a Role in an OntoUML model.
"
Class {
	#name : #MocoOntoUmlRole,
	#superclass : #MocoOntoUmlClass,
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlRole >> isSortal [
	^ true
]

{ #category : #accessing }
MocoOntoUmlRole >> providesIdentity [
	^ false
]
