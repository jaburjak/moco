"
Decomposes many-to-many associations into two many-to-one associations.
"
Class {
	#name : #MocoUmlManyToManyAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #'private - testing' }
MocoUmlManyToManyAssociationTransformationRule >> checkIfManyToMany: aMocoUmlAssociation [
	"Returns true if the given association is of many-to-many kind."
	
	^ ((self checkIfSideIsMultiple: (aMocoUmlAssociation source)) and: [ self checkIfSideIsMultiple: (aMocoUmlAssociation target) ])
]

{ #category : #'private - testing' }
MocoUmlManyToManyAssociationTransformationRule >> checkIfSideIsMultiple: aMocoUmlAssociationSide [
	"Returns true if the given association side has maximal multiplicity greater than one."
	
	^ ((aMocoUmlAssociationSide multiplicity upper isUnbounded) or: [ aMocoUmlAssociationSide multiplicity upper value > 1 ])
]

{ #category : #'private - transforming' }
MocoUmlManyToManyAssociationTransformationRule >> decompose: aMocoUmlAssociation [
	"Decomposes the given many-to-many association to two many-to-one associations with an intermediating class."
	
	| class sourceAssociation targetAssociation |
	class := self generateIntermediatingClass: aMocoUmlAssociation.
	sourceAssociation := self generateSourceAssociation: aMocoUmlAssociation withIntermediating: class.
	targetAssociation := self generateTargetAssociation: aMocoUmlAssociation withIntermediating: class.
	
	(aMocoUmlAssociation source frozen) ifTrue: [
		sourceAssociation target frozen: true.
		targetAssociation source frozen: true
	].
	
	(aMocoUmlAssociation target frozen) ifTrue: [
		sourceAssociation source frozen: true.
		targetAssociation target frozen: true
	].
	
	engine addOutputElement: class;
		addOutputElement: sourceAssociation;
		addOutputElement: targetAssociation.
	
	(engine output) at: aMocoUmlAssociation putOutputElement: class;
		at: aMocoUmlAssociation putOutputElement: sourceAssociation;
		at: aMocoUmlAssociation putOutputElement: targetAssociation.
	
	engine output metaOf: class at: #generatedBy put: #MocoUmlManyToManyAssociationTransformationRule.
	
	engine removeOutputElement: aMocoUmlAssociation
]

{ #category : #transforming }
MocoUmlManyToManyAssociationTransformationRule >> execute [
	| associations |
	associations := engine output
		selectElementsOfKind: MocoUmlAssociation
		notGuarded: #MocoUmlManyToManyAssociationTransformationRule.

	associations do: [ :each | engine output guard: each with: #MocoUmlManyToManyAssociationTransformationRule ].
	
	associations := associations select: [ :each | self checkIfManyToMany: each ].
	
	associations do: [ :each | self decompose: each ]
]

{ #category : #'private - processing' }
MocoUmlManyToManyAssociationTransformationRule >> generateIntermediatingClass: aMocoUmlAssociation [
	"Generates the intermediating class for decomposing the given many-to-many association."
	
	| class infix source target |
	class := MocoUmlClass new.
	
	infix := 'To'.
	aMocoUmlAssociation name ifNotEmpty: [ infix := MocoNamingUtils toPascalCase: (aMocoUmlAssociation name) ].
	
	source := aMocoUmlAssociation source name.
	source ifEmpty: [ source := aMocoUmlAssociation source element name ].
	
	target := aMocoUmlAssociation target name.
	target ifEmpty: [ target := aMocoUmlAssociation target element name ].
	
	class name: ((MocoNamingUtils toPascalCase: source) , '_' , infix , '_' , (MocoNamingUtils toPascalCase: target)).
	
	^ class
]

{ #category : #'private - processing' }
MocoUmlManyToManyAssociationTransformationRule >> generateSourceAssociation: aMocoUmlAssociation withIntermediating: aMocoUmlClass [
	"Generates the many-to-one association from the source to the given intermediating class."
	
	| association source target |
	association := MocoUmlAssociation new.
	
	source := MocoUmlAssociationSide new.
	source element: aMocoUmlClass.
	source multiplicity lower value: (aMocoUmlAssociation target multiplicity lower value).
	source multiplicity upper value: (aMocoUmlAssociation target multiplicity upper value).
	
	target := MocoUmlAssociationSide new.
	target element: (aMocoUmlAssociation source element);
		name: (aMocoUmlAssociation source name).
	target multiplicity lower value: 1.
	target multiplicity upper value: 1.
	
	association source: source;
		target: target.
	
	^ association
]

{ #category : #'private - processing' }
MocoUmlManyToManyAssociationTransformationRule >> generateTargetAssociation: aMocoUmlAssociation withIntermediating: aMocoUmlClass [
	"Generates the many-to-one association from the target to the given intermediating class."
	
	| association source target |
	association := MocoUmlAssociation new.
	
	source := MocoUmlAssociationSide new.
	source element: aMocoUmlClass.
	source multiplicity lower value: (aMocoUmlAssociation source multiplicity lower value).
	source multiplicity upper value: (aMocoUmlAssociation source multiplicity upper value).
	
	target := MocoUmlAssociationSide new.
	target element: (aMocoUmlAssociation target element);
		name: (aMocoUmlAssociation target name).
	target multiplicity lower value: 1.
	target multiplicity upper value: 1.
	
	association source: source;
		target: target.
	
	^ association
]

{ #category : #accessing }
MocoUmlManyToManyAssociationTransformationRule >> priority [
	^ 20
]
