"
Base class for transforming OpenPonk’s part-whole associations into their Moco alternatives.
"
Class {
	#name : #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule class >> new [
	(self asString = 'MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> executeOn: anEngine [
	| associations helper |

	associations := anEngine inModel elements select: [ :e | (e innerElement isKindOf: OPUMLAssociation) and: [ e innerElement appliedStereotypes anySatisfy: [ :each | each isKindOf: self class stereotypeSelector ] ] ].
	associations := associations select: [ :e | (e meta isProcessedBy: #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule) not ].
	
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
		element meta markProcessedBy: #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule.
			
		anEngine outModel meta didChange: true.
	]
]
