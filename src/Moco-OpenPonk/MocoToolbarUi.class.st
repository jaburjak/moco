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
sqlModel := MocoRdbToSqlOracleRound transform: (dbModel second).

')
		centered
]

{ #category : #'private - processing' }
MocoToolbarUi class >> runTransformationToAlloy: aBuilder [
	| command |
	command := MocoOpenPonkRunTransformationToAlloyCommand new.
	command workbench: (aBuilder model workbench).
	
	command execute
]

{ #category : #'private - processing' }
MocoToolbarUi class >> runTransformationToSql: aBuilder [
	| command |
	command := MocoOpenPonkRunTransformationToSqlCommand new.
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
			self runTransformationToSql: aBuilder
		].
		
	(aBuilder item: #opmocotransformalloy)
		parent: #opmoco;
		label: 'Transform to Alloy';
		action: [
			self runTransformationToAlloy: aBuilder
		]
]
