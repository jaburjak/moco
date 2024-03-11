"
Base class for transforming OpenPonk’s specialized associations into their Moco alternatives.
"
Class {
	#name : #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> modelClass [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> newWithEngine: anEngine [
	(self asString = 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super newWithEngine: anEngine ]
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> stereotypeSelector [
	^ self subclassResponsibility
]

{ #category : #transforming }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> execute [
	| associations helper |

	associations := engine inModel elements select: [ :e | (e innerElement isKindOf: OPUMLAssociation) and: [ e innerElement appliedStereotypes anySatisfy: [ :each | each isKindOf: self class stereotypeSelector ] ] ].
	associations := associations select: [ :e | (e meta isProcessedBy: #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule) not ].
	
	helper := MocoOpenPonkOntoUmlAssociationHelper withEngine: engine.
	
	associations do: [ :element |
		| moco outElement |
		moco := (self class modelClass) new.
		helper initialize: moco from: (element innerElement).
		
		self modifyAssociation: moco.
		
		outElement := MocoWrappedElement from: moco.
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> modifyAssociation: aMocoOntoUmlSpecializedAssociation [
	"Can be overriden in subclasses."
]

{ #category : #accessing }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> priority [
	^ 50
]
