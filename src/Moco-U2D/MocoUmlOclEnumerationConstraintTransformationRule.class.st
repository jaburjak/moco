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
	conditions := engine input
		selectElementsOfKind: MocoOclEnumerationConstraint
		notGuarded: #MocoUmlOclEnumerationConstraintTransformationRule.
	
	conditions do: [ :each |
		| ocl |
		ocl := MocoOclRdbEnumerationConstraint new.
		ocl name: (MocoNamingUtils toUpperSnakeCase: (each name)).
		ocl context: (engine detectOutputElement: (each context) ofKind: MocoRdbTable).
		ocl column: (ocl context columns detect: [ :e | (e name) = (MocoNamingUtils toUpperSnakeCase: (each attribute name)) ]).
		ocl values addAll: (each values).
		
		(ocl column type class canUnderstand: #length:) ifTrue: [ ocl column type length: ((ocl values collect: [ :e | e size ]) max) ].
		
		engine addOutputElement: ocl withSource: each.
		engine input guard: each with: #MocoUmlOclEnumerationConstraintTransformationRule
	]
]

{ #category : #accessing }
MocoUmlOclEnumerationConstraintTransformationRule >> priority [
	^ 50
]
