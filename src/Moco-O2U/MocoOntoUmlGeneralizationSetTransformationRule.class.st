"
Transforms generalization sets from an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlGeneralizationSetTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'modelElements'
	],
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlGeneralizationSetTransformationRule >> checkIfOptimizable: aMocoOntoUmlGeneralizationSet [
	| general |
	general := aMocoOntoUmlGeneralizationSet members first supertype.
	
	(MocoOntoUmlIdentityUtils checkIfHasIdentity: general inModel: (self modelElements))
		ifFalse: [ ^ false ].
	
	aMocoOntoUmlGeneralizationSet members do: [ :each |
		| specific |
		
		((engine findOutElementsFor: each) noneSatisfy: [ :e | e isWrappingType: MocoUmlGeneralization ]) ifTrue: [ ^ false ].
		
		specific := each subtype.
		
		(specific isKindOf: MocoOntoUmlRole) ifTrue: [ ^ false ].
		
		specific attributes ifNotEmpty: [ ^ false ].
		
		(engine inModel elements anySatisfy: [ :e | ((e isWrappingType: MocoOntoUmlGeneralization) and: [ (e == each) not ]) and: [ ((e innerElement supertype) == specific) or: [ (e innerElement supertype) == specific ] ] ])
			ifTrue: [ ^ false ].
			
		(engine inModel elements anySatisfy: [ :e | (e isWrappingType: MocoOntoUmlAssociation) and: [ ((e innerElement source element) == specific) or: [ (e innerElement target element) == specific ] ] ])
			ifTrue: [ ^ false ]
	].
	
	^ true
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> execute [
	| gens |

	gens := (engine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralizationSet ])
		select: [ :e | (e meta isNotProcessedBy: #MocoOntoUmlGeneralizationSetTransformationRule) and: [ e meta outElements isEmpty ] ].
	
	gens do: [ :element |
		| option |
		option := #keep.
		
		(self checkIfOptimizable: (element innerElement)) ifTrue: [
			| question |
			question := MocoChoiceBuilder new.
	
			question question: ('Types ' , (', ' join: (element innerElement members collect: [ :e | '"', (e subtype name) , '"' ])) , ' in generalization set' , ((element innerElement name) ifEmpty: [ '' ] ifNotEmpty: [ ' "' , (element innerElement name) , '"' ]) , ' at "' , (element innerElement members first supertype name) , '" have no properties and can be optimized out. How do you want to proceed?');
				addChoice: 'Keep them' withId: #keep;
				addChoice: 'Replace with a discriminator attribute' withId: #optimize.
				
			option := engine askChoice: question
		].
		
		(option = #optimize)
			ifTrue: [
				| out members |
				out := self toDiscriminator: (element innerElement).
				out := out collect: [ :each | MocoWrappedElement from: each ].
				
				out second innerElement context attributes add: (out first innerElement).
				
				engine outModel elements add: (out second).
				element meta outElements addAll: out.
				
				members := (element innerElement members flatCollect: [ :each | (engine findOutElementsFor: each) select: [ :e | e isWrappingType: MocoUmlGeneralization ] ]) collect: [ :each | each innerElement ].
				members addAll: (members collect: [ :each | each subtype ]).
				
				engine inModel elements do: [ :each | each meta outElements removeAllSuchThat: [ :e | members anySatisfy: [ :g | g == (e innerElement) ] ] ].
				engine outModel elements removeAllSuchThat: [ :each | members anySatisfy: [ :g | g == (each innerElement) ] ].
				engine outModel meta didChange: true
			]
			ifFalse: [
				| uml outElement |
				uml := self toUmlGeneralizationSet: (element innerElement).
				
				uml ifNotNil: [
					outElement := MocoWrappedElement from: uml.
					
					engine outModel elements add: outElement.
					
					element meta outElements add: outElement.
					
					outElement innerElement covering ifTrue: [
						outElement innerElement members do: [ :each | each supertype abstract: true ]
					].

					engine outModel meta didChange: true
				]
			].
		
		element meta markProcessedBy: #MocoOntoUmlGeneralizationSetTransformationRule
	]
]

{ #category : #'private - processing' }
MocoOntoUmlGeneralizationSetTransformationRule >> generateDiscriminatorName: aMocoOntoUmlGeneralizationSet [
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

{ #category : #'private - accessing' }
MocoOntoUmlGeneralizationSetTransformationRule >> modelElements [
	modelElements ifNil: [
		modelElements := engine inModel elements collect: [ :each | each innerElement ]
	].

	^ modelElements
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> priority [
	^ 49
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationSetTransformationRule >> toDiscriminator: aMocoOntoUmlGeneralizationSet [
	| attribute ocl values |
	attribute := MocoOntoUmlAttribute new.
	attribute name: (self generateDiscriminatorName: aMocoOntoUmlGeneralizationSet);
		type: (MocoOntoUmlType newFromName: 'String');
		immutable: true.
	attribute multiplicity lower value: 1.
	attribute multiplicity upper value: 1.
	
	ocl := MocoOclEnumerationConstraint new.
	ocl context: (((engine findOutElementsFor: (aMocoOntoUmlGeneralizationSet members first supertype)) detect: [ :each | each isWrappingType: MocoUmlClass ]) innerElement).
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
MocoOntoUmlGeneralizationSetTransformationRule >> toUmlGeneralizationSet: aGeneralizationSet [
	| uml |
	uml := MocoUmlGeneralizationSet new.
	
	uml covering: (aGeneralizationSet covering);
		disjoint: (aGeneralizationSet disjoint);
		name: (aGeneralizationSet name).
	
	aGeneralizationSet members do: [ :each |
		| outElems |
		outElems := (engine findOutElementsFor: each) select: [ :e | e isWrappingType: MocoUmlGeneralization ].
		
		outElems ifNotEmpty: [ uml members add: (outElems first innerElement) ].
	].

	uml members ifEmpty: [ ^ nil ]. "Members of the OntoUML generalization set are not present in the UML model."
	                                "They were probably transformed into a different construct, making this generalization"
	^ uml                           "set unnecessary."
]
