"
Transforms OpenPonk’s OntoUML Kind into Moco’s OntoUML Kind.
"
Class {
	#name : 'MocoOpenPonkOntoUmlKindTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlClassTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlKindTransformationRule class >> modelClass [
	^ MocoOntoUmlKind
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlKindTransformationRule class >> stereotypeSelector [
	^ OntoUMLKind
]
