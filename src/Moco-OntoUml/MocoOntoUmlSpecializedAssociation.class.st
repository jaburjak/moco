"
Provides a base for specialized OntoUML associations.
"
Class {
	#name : #MocoOntoUmlSpecializedAssociation,
	#superclass : #MocoOntoUmlAssociation,
	#category : #'Moco-OntoUml-Model'
}

{ #category : #'instance creation' }
MocoOntoUmlSpecializedAssociation class >> new [
	(self asString = 'MocoOntoUmlSpecializedAssocation') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #'private - accessing' }
MocoOntoUmlSpecializedAssociation >> associationStereotype [
	^ ((self class asString) copyReplaceAll: 'MocoOntoUml' with: '') copyReplaceAll: 'Association' with: ''
]

{ #category : #printing }
MocoOntoUmlSpecializedAssociation >> printTo: aStream [
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
	
	aStream nextPutAll: '| '.
	source printTo: aStream.

	aStream cr; nextPutAll: '| '.
	target printTo: aStream.

	aStream
		cr;
		nextPutAll: '|----------------'.
]
