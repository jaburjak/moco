"
Decomposes many-to-many associations into two many-to-one associations.
"
Class {
	#name : #MocoUmlManyToManyAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #'private - processing' }
MocoUmlManyToManyAssociationTransformationRule >> checkIfManyToMany: aMocoUmlAssociation [
	^ ((self checkIfSideIsMultiple: (aMocoUmlAssociation source)) and: [ self checkIfSideIsMultiple: (aMocoUmlAssociation target) ])
]

{ #category : #'private - processing' }
MocoUmlManyToManyAssociationTransformationRule >> checkIfSideIsMultiple: aMocoUmlAssociationSide [
	^ ((aMocoUmlAssociationSide multiplicity upper isUnbounded) or: [ aMocoUmlAssociationSide multiplicity upper value > 1 ])
]

{ #category : #'private - transforming' }
MocoUmlManyToManyAssociationTransformationRule >> decompose: aMocoWrappedElement [
	| class cOut sourceAssociation sOut targetAssociation tOut |
	class := self generateIntermediatingClass: (aMocoWrappedElement innerElement).
	sourceAssociation := self generateSourceAssociation: (aMocoWrappedElement innerElement) withIntermediating: class.
	targetAssociation := self generateTargetAssociation: (aMocoWrappedElement innerElement) withIntermediating: class.
	
	cOut := MocoWrappedElement from: class.
	sOut := MocoWrappedElement from: sourceAssociation.
	tOut := MocoWrappedElement from: targetAssociation.
	
	aMocoWrappedElement meta outElements addAll: { cOut. sOut. tOut }.
	
	engine outModel elements addAll: { cOut. sOut. tOut }
]

{ #category : #transforming }
MocoUmlManyToManyAssociationTransformationRule >> execute [
	| associations |
	associations := engine outModel elements select: [ :each |
		(each isWrappingType: MocoUmlAssociation) and: [ (each meta isProcessedBy: #MocoUmlManyToManyAssociationTransformationRule) not ]
	].

	associations do: [ :each | each meta markProcessedBy: #MocoUmlManyToManyAssociationTransformationRule ].
	
	associations := associations select: [ :each | self checkIfManyToMany: (each innerElement) ].
	
	associations do: [ :each | self decompose: each ].
	
	engine outModel elements removeAllSuchThat: [ :each | associations anySatisfy: [ :a | a == each ] ].

	associations ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoUmlManyToManyAssociationTransformationRule >> generateIntermediatingClass: aMocoUmlAssociation [
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
