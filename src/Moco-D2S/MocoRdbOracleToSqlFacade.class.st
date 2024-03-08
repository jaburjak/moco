"
Facade for transforming an Oracle relational database model to SQL statements.
"
Class {
	#name : #MocoRdbOracleToSqlFacade,
	#superclass : #Object,
	#category : #'Moco-D2S-Facade'
}

{ #category : #accessing }
MocoRdbOracleToSqlFacade class >> transform: anRdbModel [
	| engine outModel |
	engine := MocoTransformationEngine new.

	engine rules add: (MocoRdbOracleTableTransformationRule newWithEngine: engine).

	outModel := MocoWrappedModel new.
	
	engine inModel: anRdbModel;
		outModel: outModel.
		
	engine transform.
	
	^ outModel.
]
