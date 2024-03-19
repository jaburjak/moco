"
Removes empty role classes from the UML model.
"
Class {
	#name : #MocoOntoUmlRoleOptimizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'modelElements'
	],
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRoleOptimizationTransformationRule >> checkIfOptimizable: aMocoOntoUmlRole [
	| associations |
	
	aMocoOntoUmlRole attributes ifNotEmpty: [ ^ false ].
	
	(engine inModel elements anySatisfy: [ :each | (each isWrappingType: MocoOntoUmlGeneralization) and: [ (each innerElement supertype) == aMocoOntoUmlRole ] ])
		ifTrue: [ ^ false ].
		
	associations := (engine inModel elements select: [ :each | each isWrappingType: MocoOntoUmlAssociation ])
		select: [ :each | ((each innerElement source element) == aMocoOntoUmlRole) or: [ (each innerElement target element) == aMocoOntoUmlRole ] ].
	
	(associations reject: [ :each | (each isWrappingType: MocoOntoUmlMediationAssociation) or: [ each isWrappingType: MocoOntoUmlMaterialAssociation ] ])
		ifNotEmpty: [ ^ false ].
	
	(((associations select: [ :each | each isWrappingType: MocoOntoUmlMediationAssociation ]) size) > 1) ifTrue: [ ^ false ].
	(((associations select: [ :each | each isWrappingType: MocoOntoUmlMaterialAssociation ]) size) > 1) ifTrue: [ ^ false ].
	
	(self findIdentityBearer: aMocoOntoUmlRole) ifNil: [ ^ false ]. "handle invalid OntoUML models"
	
	(((engine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlGeneralization) and: [ (each innerElement subtype) == aMocoOntoUmlRole ] ]) size) > 1) ifTrue: [ ^ false ].
	
	^ true
]

{ #category : #transforming }
MocoOntoUmlRoleOptimizationTransformationRule >> execute [
	| roles |
	roles := engine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlRole) and: [ each meta isNotProcessedBy: #MocoOntoUmlRoleOptimizationTransformationRule ] ].
	
	roles do: [ :each |
		(self checkIfOptimizable: (each innerElement)) ifTrue: [
			| question |
			question := MocoChoiceBuilder new.
	
			question question: ('Role "' , (each innerElement name) , '" has no properties and can be optimized out. How do you want to proceed?');
				addChoice: 'Keep as is' withId: #keep;
				addChoice: 'Remove from model' withId: #optimize.
				
			((engine askChoice: question) = #optimize) ifTrue: [
				self optimizeRole: each.
				
				engine outModel meta didChange: true
			]
		].
		
		each meta markProcessedBy: #MocoOntoUmlRoleOptimizationTransformationRule
	]
]

{ #category : #'private - processing' }
MocoOntoUmlRoleOptimizationTransformationRule >> findIdentityBearer: aMocoOntoUmlRole [
	| identityBearer |
	identityBearer := engine inModel elements select: [ :each | (each isWrappingType: MocoOntoUmlGeneralization) and: [ (each innerElement subtype) == aMocoOntoUmlRole ] ].
	identityBearer := identityBearer select: [ :each | each meta outElements anySatisfy: [ :e | e isWrappingType: MocoUmlAssociation ] ].
	
	identityBearer ifEmpty: [ ^ nil ].
	
	identityBearer := identityBearer first innerElement supertype.
	
	^ ((engine findOutElementsFor: identityBearer) detect: [ :each | each isWrappingType: MocoUmlClass ]) innerElement
]

{ #category : #accessing }
MocoOntoUmlRoleOptimizationTransformationRule >> modelElements [
	modelElements ifNil: [
		modelElements := engine inModel elements collect: [ :each | each innerElement ]
	].

	^ modelElements
]

{ #category : #'private - transforming' }
MocoOntoUmlRoleOptimizationTransformationRule >> optimizeRole: aMocoWrappedElement [
	| roleClass identityBearer associations |
	roleClass := ((engine findOutElementsFor: (aMocoWrappedElement innerElement)) detect: [ :each | each isWrappingType: MocoUmlClass ]) innerElement.
	identityBearer := self findIdentityBearer: (aMocoWrappedElement innerElement).
	
	associations := engine outModel elements select: [ :each | each isWrappingType: MocoUmlAssociation ].
	
	(associations select: [ :each | ((each innerElement source element) == roleClass) and: [ (each innerElement target element) ~= identityBearer ] ]) do: [ :each |
		each innerElement source element: identityBearer.
		each innerElement target multiplicity lower: (MocoUmlMultiplicityBound value: 0).
		each innerElement source name: (MocoNamingUtils toFirstLowerCase: (aMocoWrappedElement innerElement name))
	].
	
	(associations select: [ :each | ((each innerElement target element) == roleClass) and: [ (each innerElement source element) ~= identityBearer ] ]) do: [ :each |
		each innerElement target element: identityBearer.
		each innerElement source multiplicity lower: (MocoUmlMultiplicityBound value: 0)
	].
	
	engine outModel elements removeAllSuchThat: [ :each | (each isWrappingType: MocoUmlAssociation) and: [ ((each innerElement source element) == roleClass) or: [ (each innerElement target element) == roleClass ] ] ].
	
	engine outModel elements removeAllSuchThat: [ :each | (each innerElement) == roleClass ]
]

{ #category : #accessing }
MocoOntoUmlRoleOptimizationTransformationRule >> priority [
	^ 10
]
