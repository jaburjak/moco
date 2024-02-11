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
	MocoOntoUmlModelStorage model: aModel.
	
	StPlayground openContents: '| ontoModel |
ontoModel := MocoOntoUmlModelStorage model.'.
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
