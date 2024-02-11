"
Transforms UML Classes into Oracle RDB tables.
"
Class {
	#name : #MocoUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #accessing }
MocoUmlClassTransformationRule >> executeOn: anEngine [
	| classes |

	classes := (anEngine inModel elements select: [ :e | e isWrappingType: MocoUmlClass ]) select: [ :e | e meta outElements isEmpty ].
	
	classes do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toTable: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoUmlClassTransformationRule >> priority [
	^ 100 
]

{ #category : #'as yet unclassified' }
MocoUmlClassTransformationRule >> toTable: anUmlClass [
	| table |
	table := MocoRdbOracleTable new.
	
	table name: (self transformClassName: anUmlClass name).
	
	^ table
]

{ #category : #'as yet unclassified' }
MocoUmlClassTransformationRule >> transformClassName: aString [
	| name |
	name := OrderedCollection new.

	aString do: [ :l | (l isLetter and: (l = (l asUppercase))) ifTrue: [ name add: '_' ]. name add: l asString asUppercase ].

	(name first = '_') ifTrue: [ name := name allButFirst: 1 ].

	name := String streamContents: [ :stream | name do: [ :each | (each = ' ') ifTrue: [ stream nextPutAll: '_' ] ifFalse: [ stream nextPutAll: each ] ] ].
	
	^ name
]
