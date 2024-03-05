"
Facade for transforming an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlToUmlFacade,
	#superclass : #Object,
	#category : #'Moco-O2U-Facade'
}

{ #category : #'private - accessing' }
MocoOntoUmlToUmlFacade class >> listTransformationRules [
	^ (RPackageOrganizer default packageNamed: 'Moco-O2U') definedClasses select: [ :each |
		|  className |
		className := each asString.
		(className beginsWith: 'MocoOntoUml') and: [ className endsWith: 'TransformationRule' ]
	]
]

{ #category : #accessing }
MocoOntoUmlToUmlFacade class >> transform: aOntoUmlModel [
	| engine outModel |
	engine := MocoTransformationEngine new.

	self listTransformationRules do: [ :each | engine rules add: (each new) ].

	outModel := MocoWrappedModel new.
	
	engine inModel: aOntoUmlModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]
