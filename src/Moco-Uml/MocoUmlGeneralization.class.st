"
Represents a generalization relationship in a UML model.
"
Class {
	#name : #MocoUmlGeneralization,
	#superclass : #MocoUmlModelElement,
	#instVars : [
		'supertype',
		'subtype'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlGeneralization >> printTo: aStream [
	aStream
		nextPutAll: '+--UML-----------';
		cr;
		nextPutAll: '| <<Generalization>>';
		cr;
		nextPutAll: '| ' , supertype name , ' <- ' , subtype name;
		cr;
		nextPutAll: '+----------------'.
]

{ #category : #accessing }
MocoUmlGeneralization >> subtype [
	^ subtype
]

{ #category : #accessing }
MocoUmlGeneralization >> subtype: anObject [
	subtype := anObject
]

{ #category : #accessing }
MocoUmlGeneralization >> supertype [
	^ supertype
]

{ #category : #accessing }
MocoUmlGeneralization >> supertype: anObject [
	supertype := anObject
]
