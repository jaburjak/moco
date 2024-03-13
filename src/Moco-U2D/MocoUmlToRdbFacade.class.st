"
Facade for transforming a UML model to Oracle relational database.
"
Class {
	#name : #MocoUmlToRdbFacade,
	#superclass : #Object,
	#category : #'Moco-U2D-Facade'
}

{ #category : #'private - transforming' }
MocoUmlToRdbFacade class >> preprocess: aUmlModel [
	| engine outModel |
	engine := MocoTransformationEngine new.

	engine rules
		add: (MocoUmlRdbCopyTransformationRule newWithEngine: engine);
		add: (MocoUmlNonNativeRdbTypeTransformationRule newWithEngine: engine);
		add: (MocoUmlMultiValueAttributeTransformationRule newWithEngine: engine).

	outModel := MocoWrappedModel new.
	
	engine inModel: aUmlModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]

{ #category : #accessing }
MocoUmlToRdbFacade class >> transform: aUmlModel [
	| preModel outModel |
	preModel := self preprocess: aUmlModel.
	
	outModel := preModel.
	
	^ { preModel. outModel }.
]
