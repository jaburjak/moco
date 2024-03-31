"
UI command that transforms an OntoUML model to SQL and displays the results.
"
Class {
	#name : #MocoOpenPonkRunTransformationsCommand,
	#superclass : #Object,
	#instVars : [
		'workbench'
	],
	#category : #'Moco-OpenPonk-Ui'
}

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> addModel: aMocoWrappedModel withLabel: aString toTranscript: aMocoTranscriptPresenter [
	| str |
	str := String new writeStream.
	
	MocoModelPrinter print: aMocoWrappedModel to: str.
	
	aMocoTranscriptPresenter addSection: (str contents) withLabel: aString
]

{ #category : #'private - accessing' }
MocoOpenPonkRunTransformationsCommand >> currentWorkbenchDiagram [
	"Returns the currently focused diagram controller from the workbench that invoked this command."
	
	^ workbench focusedEditor diagramController
]

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> determineModelName: aString or: aString2 [
	"Returns the first string in case the OntoUML model has the default name. Otherwise returns the second string appended to the name of the OntoUML model."
	
	| name |
	name := self currentWorkbenchDiagram model name.
	
	(name = 'OntoUML Model')
		ifTrue: [ ^ aString ]
		ifFalse: [ ^ name , ' (' , aString2 , ')' ]
]

{ #category : #execution }
MocoOpenPonkRunTransformationsCommand >> execute [
	| ontoModel umlModel dbModel sqlModel transcript models |
	
	ontoModel := self readOntoUmlModel.
	umlModel := MocoOntoUmlToUmlFacade transform: ontoModel.
	dbModel := MocoUmlToRdbFacade transform: umlModel.
	sqlModel := MocoRdbOracleToSqlFacade transform: (dbModel last).
	
	transcript := (MocoSpApplication instance) new: MocoTranscriptPresenter.
	
	self addModel: ontoModel withLabel: 'OntoUML' toTranscript: transcript.
	self addModel: umlModel withLabel: 'UML' toTranscript: transcript.
	self addModel: (dbModel first) withLabel: 'UML for RDB' toTranscript: transcript.
	self addModel: (dbModel last) withLabel: 'Database' toTranscript: transcript.
	self addModel: sqlModel withLabel: 'Oracle SQL' toTranscript: transcript.
	
	models := OrderedCollection new.
	models add: (self packageModel: umlModel as: (self determineModelName: 'UML Model' or: 'UML') usingRulesWithTag: 'Rule-Uml' andClassPrefix: 'MocoOpenPonkUml');
		add: (self packageModel: (dbModel first) as: (self determineModelName: 'UML Model for RDB' or: 'UML for RDB') usingRulesWithTag: 'Rule-Uml' andClassPrefix: 'MocoOpenPonkUml');
		add: (self packageModel: (dbModel last) as: (self determineModelName: 'RDB Model' or: 'RDB') usingRulesWithTag: 'Rule-Rdb' andClassPrefix: 'MocoOpenPonkRdb').
	
	transcript open.
	transcript tabs layout children last click.
	transcript body takeKeyboardFocus.
	
	self showModels: models andTranscript: transcript
]

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> openModels: aCollection in: anOPWorkbench [
	"Adds the given collection of models to the given workbench instance, opens them and focuses the last one."
	
	| controller |
	controller := anOPWorkbench projectController.
	
	aCollection do: [ :each |
		| name |
		name := MocoUniqueNameGenerator at: [ :n | controller project models anySatisfy: [ :m | (m name) = n ] ] seed: (each name) format: [ :s :i | s , ' (' , (i asString) , ')' ].
		each name: name.
	].
	
	aCollection do: [ :each | controller project addModel: each ].
	
	controller project ensureModelsHaveDiagrams.
	
	controller project diagrams do: [ :each |
		(each modelElements anySatisfy: [ :e | aCollection anySatisfy: [ :m | e == m ] ]) ifTrue: [
			anOPWorkbench openEditorOnDiagram: each
		]
	].
	
	aCollection do: [ :each |
		controller controllers do: [ :eachController |
			(eachController hasControllerForModel: each) ifTrue: [ self showElementsIn: eachController ]
		]
	].
	
	controller controllers do: [ :each |
		(each hasControllerForModel: (aCollection last)) ifTrue: [
			anOPWorkbench focusEditorOf: (each diagramController diagramElement)
		]
	]
]

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> openOpenPonk: aCollection [
	"Opens a new OpenPonk workbench instance."
	
	| project wb |
	project := OPProject new.
	project name: 'Transformation Result'.
	
	wb := OPWorkbench openProject: project.
	
	self openModels: aCollection in: wb.
	
	wb withWindowDo: [ :each | each centered ]
]

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> packageModel: aMocoModel as: aString usingRulesWithTag: aString2 andClassPrefix: aString3 [
	"Returns an OPUMLPackage generated from the given model using the given transformation rules."
	
	| engine rulesRepo model |
	engine := MocoTransformationEngine new.
	
	engine input addElements: aMocoModel.
		
	rulesRepo := MocoTransformationRuleDynamicRepository new.
	rulesRepo rulesPackage: 'Moco-OpenPonk';
		rulesTag: aString2;
		classPrefix: aString3.
	
	rulesRepo injectTo: engine.
	
	engine transform.
	
	model := OPUMLPackage new name: aString.
	model packagedElements: engine output elements.
	
	^ model
]

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> readOntoUmlModel [
	"Returns a Moco OntoUML model of the currently focused OpenPonk OntoUML model."
	
	^ MocoOpenPonkOntoUmlModelFactory createMoco: (self currentWorkbenchDiagram model)
]

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> showElementsIn: anOPDiagramController [
	"Shows all elements in the given diagram."
	
	| facade |
	
	anOPDiagramController showAllElements;
		applyDefaultLayout.
	
	facade := OPShowHideFacade on: anOPDiagramController.
	
	(anOPDiagramController model packagedElements select: [ :e | e isKindOf: OPUMLAssociation ]) do: [ :a | "hides attributes generated by navigable associations"
		| attr |
		attr := a memberEnds at: 2.
		facade hide: (OrderedCollection with: attr).
		attr name: ''
	]
]

{ #category : #'private - processing' }
MocoOpenPonkRunTransformationsCommand >> showModels: aCollection andTranscript: aMocoTranscriptPresenter [
	| mode |
	mode := MocoSettings openMode.

	(mode = 'Current window') ifTrue: [
		aMocoTranscriptPresenter centered.
		self openModels: aCollection in: workbench.
		^ self
	].
	
	"New window (default)"
	aMocoTranscriptPresenter window maximize.
	self openOpenPonk: aCollection.
	
	^ self
]

{ #category : #accessing }
MocoOpenPonkRunTransformationsCommand >> workbench [
	^ workbench
]

{ #category : #accessing }
MocoOpenPonkRunTransformationsCommand >> workbench: anOPWorkbench [
	workbench := anOPWorkbench
]
