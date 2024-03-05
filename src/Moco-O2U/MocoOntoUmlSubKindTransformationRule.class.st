"
Transforms OntoUML SubKind into a UML Class.
"
Class {
	#name : #MocoOntoUmlSubKindTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlSubKindTransformationRule class >> modelSelector [
	^ MocoOntoUmlSubKind
]
