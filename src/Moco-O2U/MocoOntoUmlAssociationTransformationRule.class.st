"
Transforms OntoUML associations into UML.
"
Class {
	#name : #MocoOntoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlAssociation
]

{ #category : #accessing }
MocoOntoUmlAssociationTransformationRule >> executeOn: anEngine [
	| associations |
	associations := anEngine inModel elements select: [ :each | (each isWrappingType: (self class modelSelector)) and: [ (each meta outElements isEmpty) and: [ (each meta isProcessedBy: #MocoOntoUmlAssociationTransformationRule) not ] ] ].
	
	associations do: [ :each |
		| uml source target out |

		uml := MocoUmlAssociation new.
		uml name: (each innerElement name);
			derived: (each innerElement derived).
		
		source := MocoUmlAssociationSide new.
		source element: ((anEngine findOutElementsFor: (each innerElement source element)) first innerElement);
			visibility: (each innerElement source visibility);
			multiplicity: (each innerElement source multiplicity);
			name: (each innerElement source name).
		
		target := MocoUmlAssociationSide new.
		target element: ((anEngine findOutElementsFor: (each innerElement target element)) first innerElement);
			visibility: (each innerElement target visibility);
			multiplicity: (each innerElement target multiplicity);
			name: (each innerElement target name).
		
		uml source: source;
			target: target.

		((self modifyAssociation: uml fromOriginal: each onEngine: anEngine) = false)
			ifFalse: [
				out := MocoWrappedElement from: uml.
				each meta outElements add: out.
				anEngine outModel elements add: out.
				anEngine outModel meta didChange: true.
			].
		
		each meta markProcessedBy: #MocoOntoUmlAssociationTransformationRule.
	]
]

{ #category : #'private - processing' }
MocoOntoUmlAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoWrappedElement onEngine: anEngine [
	"may be implemented in subclasses"
]

{ #category : #accessing }
MocoOntoUmlAssociationTransformationRule >> priority [
	^ 43
]
