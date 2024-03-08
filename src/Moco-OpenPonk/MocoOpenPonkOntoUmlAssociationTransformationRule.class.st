"
Transforms OpenPonk’s OntoUML association to a Moco OntoUML association.
"
Class {
	#name : #MocoOpenPonkOntoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationTransformationRule >> execute [
	| associations helper |
	
	associations := MocoOpenPonkUmlQuery selectElementsFrom: (engine inModel) ofStereotype: nil ofClass: OPUMLAssociation ignore: #MocoOpenPonkOntoUmlAssociationTransformationRule.
	
	helper := MocoOpenPonkOntoUmlAssociationHelper withEngine: engine.
	
	associations do: [ :element |
		| moco outElement |
		moco := MocoOntoUmlAssociation new.
		helper initialize: moco from: (element innerElement).
		
		outElement := MocoWrappedElement from: moco.
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOpenPonkOntoUmlAssociationTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformationRule >> priority [
	^ 51
]
