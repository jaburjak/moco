"
Transforms OpenPonk’s OntoUML Kind into Moco’s OntoUML Kind.
"
Class {
	#name : #MocoOpenPonkOntoUmlKindTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #accessing }
MocoOpenPonkOntoUmlKindTransformationRule >> executeOn: anEngine [
	| kinds |

	kinds := MocoOpenPonkUmlQuery selectElementsFrom: (anEngine inModel) ofStereotype: 'OntoUMLKind'.
	
	kinds do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toMocoKind: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlKindTransformationRule >> priority [
	^ 100
]

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlKindTransformationRule >> toMocoKind: aKind [
	| moco |
	moco := MocoOntoUmlKind new.
	
	MocoOpenPonkOntoUmlSortalHelper initialize: moco from: aKind.
		
	^ moco
]
