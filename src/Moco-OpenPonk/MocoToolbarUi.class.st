"
OntoUML editor toolbar extension.
"
Class {
	#name : #MocoToolbarUi,
	#superclass : #SpPresenter,
	#category : #'Moco-OpenPonk-Ui'
}

{ #category : #'private - processing' }
MocoToolbarUi class >> openMocoPlayground: aModel [
	MocoOpenPonkModelStorage ontoUmlModel: aModel.
	
	(StPlayground openContents: '| openPonkModel ontoModel umlModel dbModel sqlModel |
openPonkModel := MocoOpenPonkModelStorage ontoUmlModel.

ontoModel := MocoOpenPonkOntoUmlTransformationRound createMoco: openPonkModel.
umlModel := MocoOntoUmlToUmlRound transform: ontoModel.
dbModel := MocoUmlToRdbRound transform: umlModel.
sqlModel := MocoRdbOracleToSqlRound transform: (dbModel second).

')
		centered
]

{ #category : #'private - processing' }
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
	
	(aBuilder item: #opmoco)
		label: 'Moco';
		icon: MocoIcons mocoIcon;
		action: [ ].
	
	(aBuilder item: #opmocoplayground)
		parent: #opmoco;
		label: 'Open Playground';
		action: [
			self openMocoPlayground: (aBuilder model diagramController model)
		].
		
	(aBuilder item: #opmocotransformsql)
		parent: #opmoco;
		label: 'Transform to SQL';
		action: [
			self runTransformations: aBuilder
		]
]
