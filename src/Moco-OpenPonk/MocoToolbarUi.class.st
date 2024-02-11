"
OntoUML editor toolbar extension.
"
Class {
	#name : #MocoToolbarUi,
	#superclass : #SpPresenter,
	#category : #'Moco-OpenPonk-Ui'
}

{ #category : #'as yet unclassified' }
MocoToolbarUi class >> openMocoPlayground: aModel [
	MocoOpenPonkModelStorage ontoUmlModel: aModel.
	
	StPlayground openContents: '| openPonkModel ontoModel umlModel |
openPonkModel := MocoOpenPonkModelStorage ontoUmlModel.

ontoModel := MocoOpenPonkOntoUmlModelFactory createMoco: openPonkModel.

umlModel := MocoOntoUmlToUmlFacade transform: ontoModel.

umlModel elements collect: [ :each | each innerElement ].'.
]

{ #category : #toolbar }
MocoToolbarUi class >> toolbarMenu: aBuilder [
	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| appliedProfiles |
	appliedProfiles := aBuilder model diagramController model profileApplications collect: #appliedProfile.
	(appliedProfiles noneSatisfy: [ :each | each name = 'OntoUML' ]) ifTrue: [ ^ self ].
	
	(aBuilder item: 'Open Moco playground')
		icon: OPCoreIcons openponkIcon;
		action: [ 
			self openMocoPlayground: (aBuilder model diagramController model) ].
]
