"
Facade for transforming an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlToUmlFacade,
	#superclass : #Object,
	#category : #'Moco-O2U-Facade'
}

{ #category : #accessing }
MocoOntoUmlToUmlFacade class >> transform: aOntoUmlModel [
	| engine outModel |
	engine := MocoTransformationEngine new.

	engine rules add: (MocoOntoUmlKindTransformationRule new).

	outModel := MocoWrappedModel new.
	
	engine inModel: aOntoUmlModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]
