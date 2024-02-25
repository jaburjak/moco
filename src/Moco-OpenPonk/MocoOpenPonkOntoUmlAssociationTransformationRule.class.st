"
Transforms OpenPonk’s OntoUML association to a Moco OntoUML association.
"
Class {
	#name : #MocoOpenPonkOntoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformationRule >> executeOn: anEngine [
	| associations helper |

	associations := anEngine inModel elements select: [ :e | MocoOpenPonkUmlQuery isElement: (e innerElement) ofStereotype: nil ofClass: OPUMLAssociation ].
	associations := associations select: [ :e | e meta outElements isEmpty ].
	
	helper := MocoOpenPonkOntoUmlAssociationHelper withEngine: anEngine.
	
	associations do: [ :element |
		| moco outElement |
		moco := MocoOntoUmlAssociation new.
		helper initialize: moco from: (element innerElement).
		
		outElement := MocoWrappedElement from: moco.
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformationRule >> priority [
	^ 50
]
