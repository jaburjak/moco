"
Facade for transforming a UML model to Oracle relational database.
"
Class {
	#name : #MocoUmlToRdbOracleFacade,
	#superclass : #Object,
	#category : #'Moco-U2D-Facade'
}

{ #category : #accessing }
MocoUmlToRdbOracleFacade class >> transform: aUmlModel [
	| engine outModel |
	engine := MocoTransformationEngine new.

	engine rules add: (MocoUmlClassTransformationRule newWithEngine: engine).

	outModel := MocoWrappedModel new.
	
	engine inModel: aUmlModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]
