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
	
	StPlayground openContents: '| openPonkModel ontoModel umlModel dbModel sqlModel |
openPonkModel := MocoOpenPonkModelStorage ontoUmlModel.

ontoModel := MocoOpenPonkOntoUmlModelFactory createMoco: openPonkModel.
umlModel := MocoOntoUmlToUmlFacade transform: ontoModel.
dbModel := MocoUmlToRdbOracleFacade transform: umlModel.
sqlModel := MocoRdbOracleToSqlFacade transform: dbModel.

sqlModel elements collect: [ :each | each innerElement toSql ].'.
]

{ #category : #'as yet unclassified' }
MocoToolbarUi class >> runTransformations: aModel [
	| ontoModel umlModel dbModel "sqlModel" |

	ontoModel := MocoOpenPonkOntoUmlModelFactory createMoco: aModel.
	umlModel := MocoOntoUmlToUmlFacade transform: ontoModel.
	dbModel := MocoUmlToRdbFacade transform: umlModel.
	"sqlModel := MocoRdbOracleToSqlFacade transform: (dbModel last)."
	
	Transcript clear.
	
	MocoModelPrinter printToTranscript: ontoModel withTitle: 'OntoUML'.
	Transcript cr.
	MocoModelPrinter printToTranscript: umlModel withTitle: 'UML'.
	Transcript cr.
	MocoModelPrinter printToTranscript: (dbModel first) withTitle: 'UML (preprocessed for database)'.
	Transcript cr.
	MocoModelPrinter printToTranscript: (dbModel last) withTitle: 'Database'.
	"Transcript cr.
	MocoModelPrinter printToTranscript: sqlModel withTitle: 'SQL'."
	
	(Transcript openLabel: 'Transformation Result') maximize.
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
		
	(aBuilder item: 'Run Moco transformations')
		icon: OPCoreIcons openponkIcon;
		action: [ 
			self runTransformations: (aBuilder model diagramController model) ].
]
