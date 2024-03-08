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
	^ (RPackageOrganizer default packageNamed: 'Moco-O2U') definedClasses
		select: [ :each |
			|  className |
			className := each asString.
			(className beginsWith: 'MocoOntoUml') and: [ className endsWith: 'TransformationRule' ]
		]
]

{ #category : #accessing }
MocoOntoUmlToUmlFacade class >> transform: aOntoUmlModel [
	| engine outModel |
	engine := MocoTransformationEngine new.

	engine rules addAll: (((self listTransformationRules) collect: [ :each | [ each newWithEngine: engine ] on: SubclassResponsibility do: [ nil ] ]) select: [ :each | each isNotNil ]).

	outModel := MocoWrappedModel new.
	
	engine inModel: aOntoUmlModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]
