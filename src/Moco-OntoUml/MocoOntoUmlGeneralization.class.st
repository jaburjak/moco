"
Represents a generalization relationship in an OntoUML model.
"
Class {
	#name : #MocoOntoUmlGeneralization,
	#superclass : #MocoOntoUmlModelElement,
	#instVars : [
		'supertype',
		'subtype'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #printing }
MocoOntoUmlGeneralization >> printTo: aStream [
	aStream
		nextPutAll: '|--OntoUML-------';
		cr;
		nextPutAll: '| <<Generalization>>';
		cr;
		nextPutAll: '| ' , supertype name , ' is a supertype of ' , subtype name;
		cr;
		nextPutAll: '|----------------'.
]

{ #category : #accessing }
MocoOntoUmlGeneralization >> subtype [
	^ subtype
]

{ #category : #accessing }
MocoOntoUmlGeneralization >> subtype: anObject [
	subtype := anObject
]

{ #category : #accessing }
MocoOntoUmlGeneralization >> supertype [
	^ supertype
]

{ #category : #accessing }
MocoOntoUmlGeneralization >> supertype: anObject [
	supertype := anObject
]
