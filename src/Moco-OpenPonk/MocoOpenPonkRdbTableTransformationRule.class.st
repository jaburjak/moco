"
Transforms a table element from a relational model into OpenPonk’s class model.
"
Class {
	#name : #MocoOpenPonkRdbTableTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Rdb'
}

{ #category : #transforming }
MocoOpenPonkRdbTableTransformationRule >> execute [
	| tables |
	tables := engine inModel elements select: [ :each | (each isWrappingType: MocoRdbTable) and: [ each meta isNotProcessedBy: #MocoOpenPonkRdbTableTransformationRule ] ].
	
	tables do: [ :each |
		| table |
		table := self toOpenPonkElement: (each innerElement).
		table := MocoWrappedElement from: table.
		
		each meta outElements add: table.
		engine outModel elements add: table.
		
		each meta markProcessedBy: #MocoOpenPonkRdbTableTransformationRule
	].

	tables ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #accessing }
MocoOpenPonkRdbTableTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> toOpenPonkElement: aMocoRdbTable [
	| op |
	op := OPUMLClass new.
	
	op name: (aMocoRdbTable name).
	
	aMocoRdbTable columns do: [ :each |
		| prop |
		prop := self transformColumn: each.
	
		op ownedAttributes add: prop
	].

	aMocoRdbTable constraints do: [ :each |
		| prop |
		prop := self transformConstraint: each.
	
		op ownedAttributes add: prop
	].
	
	^ op
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformColumn: aMocoRdbColumn [
	| prop |
	prop := OPUMLProperty new.
	
	prop name: (aMocoRdbColumn name).
	
	prop type: (OPUMLPrimitiveType new).
	prop type name: (aMocoRdbColumn type typeDefinition).
	
	aMocoRdbColumn nullable
		ifTrue: [ prop type name: ((prop type name) , ' NULLABLE') ].
	
	prop upperValue: (OPUMLLiteralUnlimitedNatural new value: 1).
		
	^ prop
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformConstraint: aMocoRdbConstraint [
	| prop name |
	prop := OPUMLProperty new.
	
	name := String new writeStream.
	aMocoRdbConstraint printTo: name.
	
	prop name: (' ' , (name contents)). "Insert a non-breaking space at the beginning to force OpenPonk to put the property"
	                                    "after all other properties when rendering the diagram."
		
	^ prop
]
