"
Represents a generalization set in an OntoUML model.
"
Class {
	#name : #MocoOntoUmlGeneralizationSet,
	#superclass : #MocoOntoUmlModelElement,
	#instVars : [
		'name',
		'members',
		'disjoint',
		'covering'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlGeneralizationSet >> covering [
	^ covering
]

{ #category : #testing }
MocoOntoUmlGeneralizationSet >> covering: aBoolean [
	covering := aBoolean
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSet >> disjoint [
	^ disjoint
]

{ #category : #testing }
MocoOntoUmlGeneralizationSet >> disjoint: aBoolean [
	disjoint := aBoolean
]

{ #category : #testing }
MocoOntoUmlGeneralizationSet >> ifCovering: aBlock [
	covering ifTrue: aBlock
]

{ #category : #testing }
MocoOntoUmlGeneralizationSet >> ifDisjoint: aBlock [
	disjoint ifTrue: aBlock
]

{ #category : #testing }
MocoOntoUmlGeneralizationSet >> ifNotCovering: aBlock [
	covering ifFalse: aBlock
]

{ #category : #testing }
MocoOntoUmlGeneralizationSet >> ifNotDisjoint: aBlock [
	disjoint ifFalse: aBlock
]

{ #category : #initialization }
MocoOntoUmlGeneralizationSet >> initialize [
	super initialize.
	
	name := ''.
	disjoint := false.
	covering := false.
	members := OrderedCollection new.
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSet >> members [
	^ members
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSet >> name [
	^ name
]

{ #category : #testing }
MocoOntoUmlGeneralizationSet >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOntoUmlGeneralizationSet >> printTo: aStream [
	aStream
		nextPutAll: '|--OntoUML-------';
		cr;
		nextPutAll: '| <<GeneralizationSet>>';
		cr;
		nextPutAll: '| ' , name;
		cr.
	
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
