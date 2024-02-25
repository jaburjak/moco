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
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> new [
	(self asString = 'MocoOpenPonkOntoUmlSpecializedAssocationTransformationRule') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> stereotypeSelector [
	^ self subclassResponsibility
]

{ #category : #accessing }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> executeOn: anEngine [
	| associations helper |

	associations := anEngine inModel elements select: [ :e | (e innerElement isKindOf: OPUMLAssociation) and: (e innerElement appliedStereotypes anySatisfy: [ :each | each isKindOf: self class stereotypeSelector ]) ].
	associations := associations select: [ :e | e meta outElements isEmpty ].
	
	helper := MocoOpenPonkOntoUmlAssociationHelper withEngine: anEngine.
	
	associations do: [ :element |
		| moco outElement |
		moco := (self class modelClass) new.
		helper initialize: moco from: (element innerElement).
		
		outElement := MocoWrappedElement from: moco.
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> priority [
	^ 50
]
