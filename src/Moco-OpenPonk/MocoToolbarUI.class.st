"
OntoUML editor toolbar extension.
"
Class {
	#name : #MocoToolbarUI,
	#superclass : #SpPresenter,
	#category : #'Moco-OpenPonk-UI'
}

{ #category : #'as yet unclassified' }
MocoToolbarUI class >> openMocoPlayground: aModel [
	OntoUMLModelStorage model: aModel.
	
	StPlayground openContents: '| ontoModel |
ontoModel := OntoUMLModelStorage model.'.
]

{ #category : #toolbar }
MocoToolbarUI class >> toolbarMenu: aBuilder [
	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| appliedProfiles |
	appliedProfiles := aBuilder model diagramController model profileApplications collect: #appliedProfile.
	(appliedProfiles noneSatisfy: [ :each | each name = 'OntoUML' ]) ifTrue: [ ^ self ].
	
	(aBuilder item: 'Open Moco playground')
		icon: OPCoreIcons openponkIcon;
		action: [ 
			self openMocoPlayground: (aBuilder model diagramController model) ].
]
