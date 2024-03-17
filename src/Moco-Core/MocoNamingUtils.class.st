"
Utilities for transforming element names.
"
Class {
	#name : #MocoNamingUtils,
	#superclass : #Object,
	#category : #'Moco-Core-Utils'
}

{ #category : #transforming }
MocoNamingUtils class >> toCamelCase: aString [
	| str |
	str := aString asCamelCase.
	str := self toFirstLowerCase: str.
	
	^ str
]

{ #category : #transforming }
MocoNamingUtils class >> toFirstLowerCase: aString [
	aString ifEmpty: [ ^ aString ].
	
	^ (aString first asLowercase asString) , (aString allButFirst: 1)
]

{ #category : #transforming }
MocoNamingUtils class >> toFirstUpperCase: aString [
	aString ifEmpty: [ ^ aString ].
	
	^ (aString first asUppercase asString) , (aString allButFirst: 1)
]

{ #category : #transforming }
MocoNamingUtils class >> toPascalCase: aString [
	^ aString asCamelCase
]

{ #category : #transforming }
MocoNamingUtils class >> toShortName: aString [
	aString ifEmpty: [ ^ 'x' ].
	
	^ aString first asString asLowercase
]

{ #category : #transforming }
MocoNamingUtils class >> toUpperSnakeCase: aString [
	| str |
	
	aString ifEmpty: [ ^ aString ].
	
	str := OrderedCollection new.
	
	aString withIndexDo: [ :l :i |
		(l isLetter and: (l = (l asUppercase)))
			ifTrue: [ ((i > 1) and: [ (aString at: (i - 1)) ~= ((aString at: (i - 1)) asUppercase) ]) ifTrue: [ str add: '_' ] ].
		
		str add: l asString asUppercase
	].

	str := String streamContents: [ :stream | str do: [ :each | (each = ' ') ifTrue: [ stream nextPutAll: '_' ] ifFalse: [ stream nextPutAll: each ] ] ].
	
	str := ('_+' asRegex) copy: str replacingMatchesWith: '_'.
	
	^ str
]
