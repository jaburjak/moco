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
	^ anElement appliedStereotypes contains: [ :e | e class name = aString ]
]
