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

	kinds := anEngine inModel elements select: [ :e | MocoOpenPonkUmlQuery isElement: (e innerElement) ofStereotype: 'OntoUMLKind' ].
	kinds := kinds select: [ :e | e meta outElements isEmpty ].
	
	kinds do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toMocoKind: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlKindTransformationRule >> toMocoAttributes: aKind [
	^ aKind ownedAttributes collect: [ :each |
		| attr |
		attr := MocoOntoUmlAttribute new.
		
		attr name: each name.
		each visibility ifNil: [ attr visibility: MocoUmlVisibility public. ] ifNotNil: [ attr visibility visibility: each visibility asSymbol ].
		attr static: each isStatic.
		attr multiplicity lower: each lowerValue value.
		attr multiplicity upper: each upperValue value.
		each type ifNotNil: [ attr type: each type name ].
		
		attr.
	].
]

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlKindTransformationRule >> toMocoKind: aKind [
	| moco |
	moco := MocoOntoUmlKind new.
	
	MocoOpenPonkOntoUmlSortalHelper initialize: moco from: aKind.
		
	^ moco
]
