"
Base class for transforming OpenPonk’s part-whole associations into their Moco alternatives.
"
Class {
	#name : #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #accessing }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> executeOn: anEngine [
	| associations helper |

	associations := anEngine inModel elements select: [ :e | (e innerElement isKindOf: OPUMLAssociation) and: (e innerElement appliedStereotypes anySatisfy: [ :each | each isKindOf: self class stereotypeSelector ]) ].
	associations := associations select: [ :e | e meta outElements isEmpty ].
	
	helper := MocoOpenPonkOntoUmlAssociationHelper withEngine: anEngine.
	
	associations do: [ :element |
		| moco outElement |
		moco := (self class modelClass) new.
		helper initialize: moco from: (element innerElement).
		
		moco essential: (element innerElement appliedStereotypes first essential);
			inseparable: (element innerElement appliedStereotypes first inseparable).
		
		outElement := MocoWrappedElement from: moco.
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]
