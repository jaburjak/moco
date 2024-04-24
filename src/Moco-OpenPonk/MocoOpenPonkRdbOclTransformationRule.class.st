"
Transforms OCL constraints to OpenPonk class comments.
"
Class {
	#name : #MocoOpenPonkRdbOclTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Rdb'
}

{ #category : #'private - transforming' }
MocoOpenPonkRdbOclTransformationRule >> addComment: aMocoOclConstraint [
	"Writes out the given constraint as a comment at the element generated from the constraint’s context."
	
	| class body |
	class := self findOutClassFor: (aMocoOclConstraint context).
	
	body := String new writeStream.
	
	aMocoOclConstraint printOclTo: body.
	
	MocoOpenPonkCommentUtils addComment: (body contents) to: class
]

{ #category : #transforming }
MocoOpenPonkRdbOclTransformationRule >> execute [
	| constraints |
	constraints := engine input
		selectElementsOfKind: MocoOclConstraint
		notGuarded: #MocoOpenPonkRdbOclTransformationRule.
	
	constraints do: [ :each |
		self addComment: each.
		
		engine input guard: each with: #MocoOpenPonkRdbOclTransformationRule.
		engine output setModified
	]
]

{ #category : #'private - processing' }
MocoOpenPonkRdbOclTransformationRule >> findOutClassFor: aMocoRdbTable [
	"Returns the class element that was generated from the given table."

	^ engine detectOutputElement: aMocoRdbTable ofKind: OPUMLClass
]

{ #category : #accessing }
MocoOpenPonkRdbOclTransformationRule >> priority [
	^ 50
]
