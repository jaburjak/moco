"
Provides base for part-whole kinds of OntoUML associations.
"
Class {
	#name : #MocoOntoUmlPartWholeAssociation,
	#superclass : #MocoOntoUmlSpecializedAssociation,
	#instVars : [
		'essential',
		'inseparable'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #'instance creation' }
MocoOntoUmlPartWholeAssociation class >> new [
	(self asString = 'MocoOntoUmlPartWholeAssocation') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #accessing }
MocoOntoUmlPartWholeAssociation >> essential [
	^ essential
]

{ #category : #accessing }
MocoOntoUmlPartWholeAssociation >> essential: aBoolean [
	aBoolean ifNil: [
		essential := false
	] ifNotNil: [
		essential := aBoolean
	]
]

{ #category : #initialization }
MocoOntoUmlPartWholeAssociation >> initialize [
	super initialize.

	essential := false.
	inseparable := false.
]

{ #category : #accessing }
MocoOntoUmlPartWholeAssociation >> inseparable [
	^ inseparable
]

{ #category : #accessing }
MocoOntoUmlPartWholeAssociation >> inseparable: aBoolean [
	aBoolean ifNil: [
		inseparable := false
	] ifNotNil: [
		inseparable := aBoolean
	]
]

{ #category : #printing }
MocoOntoUmlPartWholeAssociation >> printTo: aStream [
	aStream
		nextPutAll: '|--OntoUML-------';
		cr;
		nextPutAll: '| <<' , self associationStereotype , '>>';
		cr.
		
	(derived or: [ name isNotEmpty ]) ifTrue: [
		aStream
			nextPutAll: '| ' , (derived ifTrue: [ '/' ] ifFalse: [ '' ]), name;
			cr.
	 ].
	
	(essential or: inseparable) ifTrue: [ 
		aStream nextPutAll: '| {'.
		essential ifTrue: [ aStream nextPutAll: 'essential'. inseparable ifTrue: [ aStream nextPutAll: ', ' ] ].
		inseparable ifTrue: [ aStream nextPutAll: 'inseparable' ].
		aStream nextPutAll: '}'; cr.
	].

	aStream nextPutAll: '| '.
	source printTo: aStream.
	
	aStream cr; nextPutAll: '| '.
	target printTo: aStream.

	aStream
		cr;
		nextPutAll: '|----------------'.
]
