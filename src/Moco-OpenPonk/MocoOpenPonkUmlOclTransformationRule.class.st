"
Transforms OCL constraint to class comments.
"
Class {
	#name : #MocoOpenPonkUmlOclTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Uml'
}

{ #category : #'private - transforming' }
MocoOpenPonkUmlOclTransformationRule >> addComment: aMocoOclConstraint [
	"Writes out the given constraint to the class generated from the constraint’s context."
	
	| class body |
	class := self findOutClassFor: (aMocoOclConstraint context).
	
	body := String new writeStream.
	
	aMocoOclConstraint printOclTo: body.
	
	MocoOpenPonkCommentUtils addComment: (body contents) to: class
]

{ #category : #transforming }
MocoOpenPonkUmlOclTransformationRule >> execute [
	| constraints |
	constraints := engine input
		selectElementsOfKind: MocoOclConstraint
		notGuarded: #MocoOpenPonkUmlOclTransformationRule.
	
	constraints do: [ :each |
		self addComment: each.
		
		engine input guard: each with: #MocoOpenPonkUmlOclTransformationRule.
		engine output setModified
	]
]

{ #category : #'private - processing' }
MocoOpenPonkUmlOclTransformationRule >> findOutClassFor: aMocoUmlClass [
	"Returns the OpenPonk model class that was generated from the given Moco class."
	
	^ engine detectOutputElement: aMocoUmlClass ofKind: OPUMLClass
]

{ #category : #accessing }
MocoOpenPonkUmlOclTransformationRule >> priority [
	^ 40
]
