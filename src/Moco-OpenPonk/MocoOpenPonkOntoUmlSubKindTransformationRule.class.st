"
Transforms OpenPonk’s OntoUML SubKind into Moco’s OntoUML SubKind.
"
Class {
	#name : 'MocoOpenPonkOntoUmlSubKindTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlClassTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlSubKindTransformationRule class >> modelClass [
	^ MocoOntoUmlSubKind
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlSubKindTransformationRule class >> stereotypeSelector [
	^ OntoUMLSubKind
]
