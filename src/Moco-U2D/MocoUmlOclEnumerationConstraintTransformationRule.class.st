"
Transforms an OCL attribute value enumeration constraint to a relational database model.
"
Class {
	#name : #MocoUmlOclEnumerationConstraintTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #transforming }
MocoUmlOclEnumerationConstraintTransformationRule >> execute [
	| conditions |
	conditions := engine inModel elements select: [ :each | (each isWrappingType: MocoOclEnumerationConstraint) and: [ each meta isNotProcessedBy: #MocoUmlOclEnumerationConstraintTransformationRule ] ].
	
	conditions do: [ :each |
		| ocl out |
		ocl := MocoOclRdbEnumerationConstraint new.
		ocl context: ((engine findOutElementsFor: (each innerElement context)) detect: [ :e | e isWrappingType: MocoRdbTable ]) innerElement.
		ocl column: (ocl context columns detect: [ :e | (e name) = (MocoNamingUtils toUpperSnakeCase: (each innerElement attribute name)) ]).
		ocl values addAll: (each innerElement values).
		
		out := MocoWrappedElement from: ocl.
		
		each meta outElements add: out.
		each meta markProcessedBy: #MocoUmlOclEnumerationConstraintTransformationRule.
		engine outModel elements add: out
	].
	
	conditions ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #accessing }
MocoUmlOclEnumerationConstraintTransformationRule >> priority [
	^ 50
]
