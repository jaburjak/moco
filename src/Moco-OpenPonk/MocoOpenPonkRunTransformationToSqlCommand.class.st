"
UI command that transforms an OntoUML model to SQL and displays the results.
"
Class {
	#name : 'MocoOpenPonkRunTransformationToSqlCommand',
	#superclass : 'MocoOpenPonkRunTransformationsCommand',
	#category : 'Moco-OpenPonk-Ui',
	#package : 'Moco-OpenPonk',
	#tag : 'Ui'
}

{ #category : 'execution' }
MocoOpenPonkRunTransformationToSqlCommand >> execute [
	| model ontoModel umlModel dbModel sqlModel transcript models |
	model := self currentWorkbenchDiagram model.
	
	ontoModel := self readOntoUmlModel.
	umlModel := MocoOntoUmlToUmlRound transform: ontoModel withEngineDo: [ :engine | engine choiceLog: (self class choiceLog: #ontouml of: model) ].
	dbModel := MocoUmlToRdbRound transform: (umlModel output).
	sqlModel := (self sqlRound) transform: (dbModel last).
	
	self class saveChoiceLog: ({ #ontouml->(umlModel choiceLog) } asDictionary) of: model in: (self workbench).
	
	transcript := (MocoSpApplication instance) new: MocoTranscriptPresenter.
	
	self addModel: ontoModel withLabel: 'OntoUML' toTranscript: transcript.
	self addModel: (umlModel output) withLabel: 'UML' toTranscript: transcript.
	self addModel: (dbModel first) withLabel: 'UML for RDB' toTranscript: transcript.
	self addModel: (dbModel last) withLabel: 'Database' toTranscript: transcript.
	self addModel: sqlModel withLabel: (self sqlRoundLabel) toTranscript: transcript.
	
	models := OrderedCollection new.
	
	(MocoSettings openMode = 'Nowhere') ifFalse: [
		models add: (self packageModel: (umlModel output) as: (self determineModelName: 'UML Model' or: 'UML') usingRulesWithTag: 'Rule-Uml' andClassPrefix: 'MocoOpenPonkUml');
			add: (self packageModel: (dbModel first) as: (self determineModelName: 'UML Model for RDB' or: 'UML for RDB') usingRulesWithTag: 'Rule-Uml' andClassPrefix: 'MocoOpenPonkUml');
			add: (self packageModel: (dbModel last) as: (self determineModelName: 'RDB Model' or: 'RDB') usingRulesWithTag: 'Rule-Rdb' andClassPrefix: 'MocoOpenPonkRdb')
	].
	
	self showModels: models andTranscript: transcript
]

{ #category : 'private - accessing' }
MocoOpenPonkRunTransformationToSqlCommand >> sqlRound [
	| platform |
	platform := MocoSettings sqlPlatform.
	
	(platform = 'Oracle') ifTrue: [ ^ MocoRdbToSqlOracleRound ].
	(platform = 'PostgreSQL') ifTrue: [ ^ MocoRdbToSqlPostgresqlRound ].
	(platform = 'MySQL') ifTrue: [ ^ MocoRdbToSqlMysqlRound ].
	(platform = 'Microsoft SQL Server') ifTrue: [ ^ MocoRdbToSqlMssqlRound ].
	
	self error: 'Unrecognized SQL platform.'
]

{ #category : 'private - accessing' }
MocoOpenPonkRunTransformationToSqlCommand >> sqlRoundLabel [
	| platform |
	platform := MocoSettings sqlPlatform.
	
	(platform = 'Microsoft SQL Server') ifTrue: [ ^ 'MSSQL' ].
	
	(platform endsWith: 'SQL')
		ifTrue: [ ^ platform ]
		ifFalse: [ ^ (platform , ' SQL') ]
]
