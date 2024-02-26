"
Transforms OpenPonk’s OntoUML SubKind into Moco’s OntoUML SubKind.
"
Class {
	#name : #MocoOpenPonkOntoUmlSubKindTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #accessing }
MocoOpenPonkOntoUmlSubKindTransformationRule >> executeOn: anEngine [
	| subkinds |

	subkinds := MocoOpenPonkUmlQuery selectElementsFrom: (anEngine inModel) ofStereotype: 'OntoUMLSubKind'.
	
	subkinds do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toMocoSubKind: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlSubKindTransformationRule >> priority [
	^ 99
]

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlSubKindTransformationRule >> toMocoSubKind: aSubKind [
	| moco |
	moco := MocoOntoUmlSubKind new.
	
	MocoOpenPonkOntoUmlSortalHelper initialize: moco from: aSubKind.
		
	^ moco
]
