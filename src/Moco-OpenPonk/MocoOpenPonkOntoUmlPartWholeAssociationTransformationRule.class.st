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

{ #category : #transforming }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> execute [
	| associations helper |

	associations := engine inModel elements select: [ :e | (e innerElement isKindOf: OPUMLAssociation) and: [ e innerElement appliedStereotypes anySatisfy: [ :each | each isKindOf: self class stereotypeSelector ] ] ].
	associations := associations select: [ :e | (e meta isProcessedBy: #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule) not ].
	
	helper := MocoOpenPonkOntoUmlAssociationHelper withEngine: engine.
	
	associations do: [ :element |
		| moco outElement |
		moco := (self class modelClass) new.
		helper initialize: moco from: (element innerElement).
		
		moco essential: (element innerElement appliedStereotypes first essential);
			inseparable: (element innerElement appliedStereotypes first inseparable).
		
		outElement := MocoWrappedElement from: moco.
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule.
			
		engine outModel meta didChange: true.
	]
]
