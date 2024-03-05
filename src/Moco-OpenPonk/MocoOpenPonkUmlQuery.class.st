"
Helper class for querying OpenPonk’s UML model.
"
Class {
	#name : #MocoOpenPonkUmlQuery,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #testing }
MocoOpenPonkUmlQuery class >> isElement: anElement ofStereotype: aString [
	aString
		ifNil:
			[ ^ anElement appliedStereotypes isEmpty ]
		ifNotNil:
			[ ^ anElement appliedStereotypes anySatisfy: [ :e | e class name = aString ] ]
]

{ #category : #testing }
MocoOpenPonkUmlQuery class >> isElement: anElement ofStereotype: aString ofClass: aClass [
	^ (anElement isKindOf: aClass) and: [ self isElement: anElement ofStereotype: aString ]
]

{ #category : #selecting }
MocoOpenPonkUmlQuery class >> selectElementsFrom: aWrappedModel ofStereotype: aString [
	^ aWrappedModel elements select: [ :e | self isElement: (e innerElement) ofStereotype: aString ].
]

{ #category : #selecting }
MocoOpenPonkUmlQuery class >> selectElementsFrom: aWrappedModel ofStereotype: aString ignore: anObject [
	^ (self selectElementsFrom: aWrappedModel ofStereotype: aString) select: [ :each | (each meta isProcessedBy: anObject) not ]
]

{ #category : #selecting }
MocoOpenPonkUmlQuery class >> selectElementsFrom: aWrappedModel ofStereotype: aString ofClass: aClass [
	| elems |
	elems := aWrappedModel elements select: [ :e | self isElement: (e innerElement) ofStereotype: aString ofClass: aClass ].
	elems := elems select: [ :e | e meta outElements isEmpty ].
	
	^ elems
]

{ #category : #selecting }
MocoOpenPonkUmlQuery class >> selectElementsFrom: aWrappedModel ofStereotype: aString ofClass: aClass ignore: anObject [
	^ (self selectElementsFrom: aWrappedModel ofStereotype: aString ofClass: aClass) select: [ :each | (each meta isProcessedBy: anObject) not ]
]
