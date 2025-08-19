Extension { #name : 'MocoUmlType' }

{ #category : '*Moco-OpenPonk' }
MocoUmlType >> isPrimitiveType [
	"Returns true if the data type represents a primitive type according to the UML standard."
	
	^ { 'String'. 'Integer'. 'Boolean' } anySatisfy: [ :each | each = name ]
]
