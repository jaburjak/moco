"
Transforms OCL constraints to OpenPonk class comments.
"
Class {
	#name : #MocoOpenPonkRdbOclTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Rdb'
}

{ #category : #'private - transforming' }
MocoOpenPonkRdbOclTransformationRule >> addComment: aConstraint [
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
MocoOpenPonkRdbOclTransformationRule >> execute [
	| constraints |
	constraints := engine inModel elements select: [ :each | ((each isWrappingType: MocoOclCondition) or: [ each isWrappingType: MocoOclInvariant ]) and: [ each meta isNotProcessedBy: #MocoOpenPonkRdbOclTransformationRule ] ].
	
	constraints do: [ :each |
		self addComment: (each innerElement).
		
		each meta markProcessedBy: #MocoOpenPonkRdbOclTransformationRule
	].
	
	constraints ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoOpenPonkRdbOclTransformationRule >> findOutClassFor: aMocoRdbTable [
	^ ((engine findOutElementsFor: aMocoRdbTable) select: [ :each | each isWrappingType: OPUMLClass ]) first innerElement
]

{ #category : #accessing }
MocoOpenPonkRdbOclTransformationRule >> priority [
	^ 50
]
