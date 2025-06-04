"
UI command that transforms an OntoUML model to Alloy and displays the results.
"
Class {
	#name : #MocoOpenPonkRunTransformationToAlloyCommand,
	#superclass : #MocoOpenPonkRunTransformationsCommand,
	#category : #'Moco-OpenPonk-Ui'
}

{ #category : #execution }
MocoOpenPonkRunTransformationToAlloyCommand >> execute [
	| model ontoModel alloyModel transcript |
	model := self currentWorkbenchDiagram model.
	
	ontoModel := self readOntoUmlModel.
	alloyModel := MocoOntoUmlToAlloyRound transform: ontoModel.
	
	transcript := (MocoSpApplication instance) new: MocoTranscriptPresenter.
	
	self addModel: ontoModel withLabel: 'OntoUML' toTranscript: transcript.
	self addModel: alloyModel withLabel: 'Alloy' toTranscript: transcript.
	
	self showModels: (OrderedCollection new) andTranscript: transcript
]
