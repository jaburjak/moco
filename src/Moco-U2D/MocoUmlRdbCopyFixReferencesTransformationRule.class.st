"
Updates references to object copies made by MocoUmlRdbCopyTransformationRule.
"
Class {
	#name : #MocoUmlRdbCopyFixReferencesTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #transforming }
MocoUmlRdbCopyFixReferencesTransformationRule >> execute [
	self fixGeneralizations;
		fixGeneralizationSets;
		fixAssociations;
		fixOcl
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixAssociations [
	| associations |
	associations := engine outModel elements select: [ :each | (each isWrappingType: MocoUmlAssociation) and: [ each meta isNotProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule ] ].
	
	associations do: [ :each |
		| original |
		original := engine findInElementFor: each.
		
		original ifNotNil: [ "ignore associations generated in the current transformation phase"
			| source target |
			
			source := (engine findOutElementsFor: (original innerElement source element)) first innerElement.
			target := (engine findOutElementsFor: (original innerElement target element)) first innerElement.
			
			each innerElement source element: source.
			each innerElement target element: target
		].
			
		each meta markProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule
	].

	associations ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixExclusiveAssociationConditions: aCollection [
	| ocls |
	ocls := aCollection select: [ :each | each isWrappingType: MocoOclExclusiveAssociationCondition ].
	
	ocls do: [ :each |
		| original associations |
		original := engine findInElementFor: each.
		
		associations := original innerElement associations collect: [ :a |
			(engine findOutElementsFor: a) first innerElement
		].
		
		each innerElement associations removeAll.
		each innerElement associations addAll: associations
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixGeneralizationSets [
	| sets |
	sets := engine outModel elements select: [ :each | (each isWrappingType: MocoUmlGeneralizationSet) and: [ (each meta isProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule) not ] ].
	
	sets do: [ :each |
		| original members |
		original := engine findInElementFor: each.
		
		members := original innerElement members collect: [ :member |
			(engine findOutElementsFor: member) first innerElement
		].
	
		each innerElement members removeAll.
		each innerElement members addAll: members.
		
		each meta markProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule
	].

	sets ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixGeneralizations [
	| generalizations |
	generalizations := engine outModel elements select: [ :each | (each isWrappingType: MocoUmlGeneralization) and: [ (each meta isProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule) not ] ].
	
	generalizations do: [ :each |
		| original general specific |
		original := engine findInElementFor: each.
		
		general := (engine findOutElementsFor: (original innerElement supertype)) first innerElement.
		specific := (engine findOutElementsFor: (original innerElement subtype)) first innerElement.
		
		each innerElement supertype: general.
		each innerElement subtype: specific.
		
		each meta markProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule
	].

	generalizations ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixOcl [
	| ocls |
	ocls := engine outModel elements select: [ :each | ((each isWrappingType: MocoOclCondition) or: [ each isWrappingType: MocoOclInvariant ]) and: [ (each meta isProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule) not ] ].
	
	ocls do: [ :each |
		| original context |
		original := engine findInElementFor: each.
		
		context := (engine findOutElementsFor: (original innerElement context)) first innerElement.
		
		each innerElement context: context.
		
		each meta markProcessedBy: #MocoUmlRdbCopyFixReferencesTransformationRule
	].

	self fixExclusiveAssociationConditions: ocls.

	ocls ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #accessing }
MocoUmlRdbCopyFixReferencesTransformationRule >> priority [
	^ 49
]
