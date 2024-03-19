"
Transforms OCL constraint to class comments.
"
Class {
	#name : #MocoOpenPonkUmlOclTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Uml'
}

{ #category : #'private - transforming' }
MocoOpenPonkUmlOclTransformationRule >> addComment: aConstraint [
	| class body |
	class := self findOutClassFor: (aConstraint context).
	
	body := String new writeStream.
	
	aConstraint printOclTo: body.
	
	class ownedComments
		ifEmpty: [
			| comment |
			comment := OPUMLComment new.
			comment body: (body contents).
			class ownedComments add: comment
		]
		ifNotEmpty: [ 
			| comment |
			comment := class ownedComments first.
			comment body: ((comment body) , (Character cr asString) , (Character cr asString) , (body contents))
		]
]

{ #category : #transforming }
MocoOpenPonkUmlOclTransformationRule >> execute [
	| constraints |
	constraints := engine inModel elements select: [ :each | ((each isWrappingType: MocoOclCondition) or: [ each isWrappingType: MocoOclInvariant ]) and: [ each meta isNotProcessedBy: #MocoOpenPonkUmlOclTransformationRule ] ].
	
	constraints do: [ :each |
		self addComment: (each innerElement).
		
		each meta markProcessedBy: #MocoOpenPonkUmlOclTransformationRule
	].
	
	constraints ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoOpenPonkUmlOclTransformationRule >> findOutClassFor: aMocoUmlClass [
	^ ((engine findOutElementsFor: aMocoUmlClass) select: [ :each | each isWrappingType: OPUMLClass ]) first innerElement
]

{ #category : #accessing }
MocoOpenPonkUmlOclTransformationRule >> priority [
	^ 40
]
