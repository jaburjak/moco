"
Transforms OntoUML Kinds into UML Classes.
"
Class {
	#name : #MocoOntoUmlKindTransformationRule,
	#superclass : #MocoOntoUmlClassTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlKindTransformationRule class >> modelSelector [
	^ MocoOntoUmlKind
]
