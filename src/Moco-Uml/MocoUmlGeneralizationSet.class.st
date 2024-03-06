"
Represents a generalization set in a UML model.
"
Class {
	#name : #MocoUmlGeneralizationSet,
	#superclass : #MocoUmlModelElement,
	#instVars : [
		'name',
		'members',
		'disjoint',
		'covering'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlGeneralizationSet >> covering [
	^ covering
]

{ #category : #accessing }
MocoUmlGeneralizationSet >> covering: aBoolean [
	aBoolean ifNil: [
		covering := false
	] ifNotNil: [
		covering := aBoolean
	]
]

{ #category : #accessing }
MocoUmlGeneralizationSet >> disjoint [
	^ disjoint
]

{ #category : #accessing }
MocoUmlGeneralizationSet >> disjoint: aBoolean [
	aBoolean ifNil: [
		disjoint := false
	] ifNotNil: [
		disjoint := aBoolean
	]
]

{ #category : #testing }
MocoUmlGeneralizationSet >> ifCovering: aBlock [
	covering ifTrue: aBlock
]

{ #category : #testing }
MocoUmlGeneralizationSet >> ifDisjoint: aBlock [
	disjoint ifTrue: aBlock
]

{ #category : #testing }
MocoUmlGeneralizationSet >> ifNotCovering: aBlock [
	covering ifFalse: aBlock
]

{ #category : #testing }
MocoUmlGeneralizationSet >> ifNotDisjoint: aBlock [
	disjoint ifFalse: aBlock
]

{ #category : #testing }
MocoUmlGeneralizationSet >> initialize [
	super initialize.
	
	name := ''.
	disjoint := false.
	covering := false.
	members := OrderedCollection new.
]

{ #category : #accessing }
MocoUmlGeneralizationSet >> members [
	^ members
]

{ #category : #accessing }
MocoUmlGeneralizationSet >> name [
	^ name
]

{ #category : #testing }
MocoUmlGeneralizationSet >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #testing }
MocoUmlGeneralizationSet >> printTo: aStream [
	aStream
		nextPutAll: '|--UML-----------';
		cr;
		nextPutAll: '| <<GeneralizationSet>>';
		cr.
	
	name ifNotEmpty: [ aStream nextPutAll: '| ' , name; cr. ].
	
	(disjoint or: covering) ifTrue: [
		aStream nextPutAll: '| {'.
		
		disjoint ifTrue: [
			aStream nextPutAll: 'disjoint'.
			covering ifTrue: [ aStream nextPutAll: ', ' ].
		].
	
		covering ifTrue: [ aStream nextPutAll: 'complete' ].
		
		aStream nextPutAll: '}'; cr.
	].

	members do: [ :each |
		aStream nextPutAll: '| + ' , each supertype name , ' <- ' , each subtype name; cr.
	].
	
	aStream nextPutAll: '|----------------'.
]
