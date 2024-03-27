"
Transforms an OntoUML class attribute to a UML class attribute.
"
Class {
	#name : #MocoOntoUmlToUmlAttributeTransformation,
	#superclass : #Object,
	#category : #'Moco-O2U-Transformation'
}

{ #category : #transforming }
MocoOntoUmlToUmlAttributeTransformation class >> toUmlAttribute: aMocoOntoUmlAttribute [
	"Transforms the given OntoUML class attribute to a UML class attribute."
	
	| uml |
	uml := MocoUmlAttribute new
		name: (aMocoOntoUmlAttribute name);
		static: (aMocoOntoUmlAttribute static);
		immutable: (aMocoOntoUmlAttribute immutable);
		visibility: (aMocoOntoUmlAttribute visibility).
	
	aMocoOntoUmlAttribute type ifNotNil: [ uml type: (MocoUmlType newFromName: (aMocoOntoUmlAttribute type name)) ].
	
	uml multiplicity lower: (aMocoOntoUmlAttribute multiplicity lower).
	uml multiplicity upper: (aMocoOntoUmlAttribute multiplicity upper).
	
	^ uml
]
