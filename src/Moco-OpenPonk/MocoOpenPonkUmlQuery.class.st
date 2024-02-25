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
	^ (anElement isKindOf: aClass) and: (self isElement: anElement ofStereotype: aString)
]
