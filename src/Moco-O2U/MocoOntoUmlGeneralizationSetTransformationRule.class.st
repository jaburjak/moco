"
Transforms generalization sets from an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlGeneralizationSetTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlGeneralizationSetTransformationRule >> checkIfOptimizable: aMocoOntoUmlGeneralizationSet [
	"Returns true if all subtypes in the given generalization set are empty classes."
	
	| general |
	general := aMocoOntoUmlGeneralizationSet members first supertype.
	
	(MocoOntoUmlIdentityUtils checkIfHasIdentity: general inModel: (engine input elements))
		ifFalse: [ ^ false ]. "supertype has no identity"
	
	aMocoOntoUmlGeneralizationSet members do: [ :each |
		| specific |
		
		(engine detectOutputElement: each ofKind: MocoUmlGeneralization)
			ifNil: [ ^ false ]. "generalization in the set was transformed to a construct other than a UML generalization"
		
		specific := each subtype.
		
		((specific isKindOf: MocoOntoUmlRole) or: [ specific isKindOf: MocoOntoUmlPhase ])
			ifTrue: [ ^ false ]. "optimization of roles and phases is handled by other transformation rules"
		
		specific attributes
			ifNotEmpty: [ ^ false ]. "subtype has attributes"
		
		((engine input selectElementsOfKind: MocoOntoUmlGeneralization) anySatisfy: [ :e | ((e == each) not) and: [ ((e supertype) == specific) or: [ (e subtype) == specific ] ] ])
			ifTrue: [ ^ false ]. "subtype participates in multiple generalizations"
		
		((engine input selectElementsOfKind: MocoOntoUmlAssociation) anySatisfy: [ :e | e anySideIncludes: specific ])
			ifTrue: [ ^ false ] "subtype participates in associations"
	].
	
	^ true
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> execute [
	| generalizationSets |
	generalizationSets := engine input
		selectElementsOfKind: MocoOntoUmlGeneralizationSet
		notGuarded: #MocoOntoUmlGeneralizationSetTransformationRule.
	
	generalizationSets := generalizationSets reject: [ :each | (engine detectOutputElement: each) isNotNil ]. "generalization set may have already been processed by another rule"
	
	generalizationSets do: [ :each | self transformGeneralizationSet: each ]
]

{ #category : #'private - processing' }
MocoOntoUmlGeneralizationSetTransformationRule >> generateDiscriminatorName: aMocoOntoUmlGeneralizationSet [
	"Returns a unique name for a discriminator attribute corresponding to the given generalization set."
	
	aMocoOntoUmlGeneralizationSet name
		ifNotEmpty: [ ^ MocoNamingUtils toFirstLowerCase: (aMocoOntoUmlGeneralizationSet name) ]
		ifEmpty: [
			| general name count |
			general := aMocoOntoUmlGeneralizationSet members first supertype.
			name := 'discriminator'.
			count := 0.
			
			[
				count := count + 1.
				general attributes anySatisfy: [ :each | (each name) = (name , ((count = 1) ifTrue: [ '' ] ifFalse: [ count asString ])) ]
			] whileTrue.
			
			^ (name , ((count = 1) ifTrue: [ '' ] ifFalse: [ count asString ]))
		]
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> priority [
	^ 49
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationSetTransformationRule >> toDiscriminator: aMocoOntoUmlGeneralizationSet [
	"Transforms the given generalization set to a discriminator attribute on the supertype."
	
	| attribute ocl values |
	attribute := MocoOntoUmlAttribute new.
	attribute name: (self generateDiscriminatorName: aMocoOntoUmlGeneralizationSet);
		type: (MocoOntoUmlType newFromName: 'String');
		immutable: true.
	attribute multiplicity lower value: 1.
	attribute multiplicity upper value: 1.
	
	ocl := MocoOclEnumerationConstraint new.
	ocl context: (engine detectOutputElement: (aMocoOntoUmlGeneralizationSet members first supertype) ofKind: MocoUmlClass).
	ocl name: 'EN_' , (ocl context name) , '_' , (attribute name);
		attribute: attribute.
	
	values := OrderedCollection new.
	values addAll: (aMocoOntoUmlGeneralizationSet members collect: [ :each | each subtype name ]).
	
	aMocoOntoUmlGeneralizationSet ifNotDisjoint: [
		| tmp |
		tmp := values combinations collect: [ :each | '' join: each ].
		values removeAll; addAll: tmp.
	].

	aMocoOntoUmlGeneralizationSet ifNotCovering: [ values addFirst: (aMocoOntoUmlGeneralizationSet members first supertype name) ].
	
	ocl values addAll: values.
	
	^ { attribute. ocl }
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationSetTransformationRule >> toUmlGeneralizationSet: aMocoOntoUmlGeneralizationSet [
	"Transforms the given OntoUML generalization set to a UML generalization set."
	
	| uml |
	uml := MocoUmlGeneralizationSet new.
	
	uml covering: (aMocoOntoUmlGeneralizationSet covering);
		disjoint: (aMocoOntoUmlGeneralizationSet disjoint);
		name: (aMocoOntoUmlGeneralizationSet name).
	
	aMocoOntoUmlGeneralizationSet members do: [ :each |
		| generalization |
		generalization := engine detectOutputElement: each ofKind: MocoUmlGeneralization.
		
		generalization ifNotNil: [ uml members add: generalization ]
	].

	uml members ifEmpty: [ ^ nil ]. "Members of the OntoUML generalization set are not present in the UML model."
	                                "They were probably transformed into a different construct, making this generalization"
	^ uml                           "set unnecessary."
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationSetTransformationRule >> transformGeneralizationSet: aMocoOntoUmlGeneralizationSet [
	"Transforms the given OntoUML generalization set to UML."
	
	| option |
	option := #keep.
	
	(self checkIfOptimizable: (aMocoOntoUmlGeneralizationSet)) ifTrue: [
		| question |
		question := MocoChoiceBuilder new.
		
		question question: ('Types ' , (', ' join: (aMocoOntoUmlGeneralizationSet members collect: [ :e | '“', (e subtype name) , '”' ])) , ' in generalization set' , ((aMocoOntoUmlGeneralizationSet name) ifEmpty: [ '' ] ifNotEmpty: [ ' “' , (aMocoOntoUmlGeneralizationSet name) , '”' ]) , ' at “' , (aMocoOntoUmlGeneralizationSet members first supertype name) , '” have no properties and can be optimized out. How do you want to proceed?');
			addChoice: 'Keep them' withId: #keep;
			addChoice: 'Replace with a discriminator attribute' withId: #optimize.
			
		option := engine askChoice: question
	].
	
	(option = #optimize)
		ifTrue: [
			| discriminator members |
			discriminator := self toDiscriminator: aMocoOntoUmlGeneralizationSet.
			
			discriminator second context attributes add: (discriminator first).
			
			engine atInput: aMocoOntoUmlGeneralizationSet putOutputElement: (discriminator first).
			engine addOutputElement: (discriminator second) withSource: aMocoOntoUmlGeneralizationSet.
			
			members := (aMocoOntoUmlGeneralizationSet members flatCollect: [ :each | engine selectOutputElements: each ofKind: MocoUmlGeneralization ]).
			members addAll: (members collect: [ :each | each subtype ]).
			
			members do: [ :each | engine removeOutputElement: each ]
		]
		ifFalse: [
			| uml |
			uml := self toUmlGeneralizationSet: aMocoOntoUmlGeneralizationSet.
			
			uml ifNotNil: [
				engine addOutputElement: uml withSource: aMocoOntoUmlGeneralizationSet.
				
				uml covering ifTrue: [
					uml members do: [ :each | each supertype abstract: true ]
				]
			]
		].
	
	engine input guard: aMocoOntoUmlGeneralizationSet with: #MocoOntoUmlGeneralizationSetTransformationRule
]
