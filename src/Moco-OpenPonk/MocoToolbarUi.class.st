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
	
	(StPlayground openContents: '| openPonkModel ontoModel umlModel dbModel sqlModel |
openPonkModel := MocoOpenPonkModelStorage ontoUmlModel.

ontoModel := MocoOpenPonkOntoUmlModelFactory createMoco: openPonkModel.
umlModel := MocoOntoUmlToUmlFacade transform: ontoModel.
dbModel := MocoUmlToRdbFacade transform: umlModel.
sqlModel := MocoRdbOracleToSqlFacade transform: (dbModel second).

')
		centered
]

{ #category : #'as yet unclassified' }
MocoToolbarUi class >> runTransformations: aBuilder [
	| command |
	command := MocoOpenPonkRunTransformationsCommand new.
	command workbench: (aBuilder model workbench).
	
	command execute
]

{ #category : #toolbar }
MocoToolbarUi class >> toolbarMenu: aBuilder [
	<opEditorToolbarMenu: #OPUmlClassEditorPlugin>
	| appliedProfiles |
	appliedProfiles := aBuilder model diagramController model profileApplications collect: #appliedProfile.
	(appliedProfiles noneSatisfy: [ :each | each name = 'OntoUML' ]) ifTrue: [ ^ self ].
	
	(aBuilder item: 'Open Moco playground')
		icon: MocoIcons mocoIcon;
		action: [ 
			self openMocoPlayground: (aBuilder model diagramController model) ].
		
	(aBuilder item: 'Run Moco transformations')
		icon: MocoIcons mocoIcon;
		action: [ 
			self runTransformations: aBuilder ].
]
