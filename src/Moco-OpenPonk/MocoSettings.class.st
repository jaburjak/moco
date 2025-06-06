"
Provides user-configurable settings.
"
Class {
	#name : #MocoSettings,
	#superclass : #Object,
	#classVars : [
		'openMode',
		'overwriteModels',
		'sqlPlatform'
	],
	#category : #'Moco-OpenPonk-Settings'
}

{ #category : #accessing }
MocoSettings class >> openMode [
	openMode ifNil: [ openMode := 'New window' ].
	^ openMode
]

{ #category : #accessing }
MocoSettings class >> openMode: aString [
	openMode := aString
]

{ #category : #settings }
MocoSettings class >> openModeSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #openMode)
		label: 'Open transformed diagram in';
		description: 'Controls whether to open the diagrams of the transformed models in a new OpenPonk project or to add them to the original one.';
		target: MocoSettings;
		parent: #moco;
		domainValues: #(#'New window' #'Current window')
]

{ #category : #accessing }
MocoSettings class >> overwriteModels [
	overwriteModels ifNil: [ overwriteModels := 'Always ask' ].
	
	^ overwriteModels
]

{ #category : #accessing }
MocoSettings class >> overwriteModels: aString [
	overwriteModels := aString
]

{ #category : #settings }
MocoSettings class >> overwriteModelsSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #overwriteModels)
		label: 'Overwrite old transformation results?';
		description: 'When set to yes, models generated by previous transformations are automatically overwritten.';
		target: MocoSettings;
		parent: #moco;
		domainValues: #(#'Always ask' #'Yes' #'No')
]

{ #category : #settings }
MocoSettings class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #moco)
		label: 'Moco';
		description: 'OntoUML to SQL transformation settings.'
]

{ #category : #accessing }
MocoSettings class >> sqlPlatform [
	sqlPlatform ifNil: [ sqlPlatform := 'PostgreSQL' ].
	^ sqlPlatform
]

{ #category : #accessing }
MocoSettings class >> sqlPlatform: aString [
	sqlPlatform := aString
]

{ #category : #settings }
MocoSettings class >> sqlPlatformSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #sqlPlatform)
		label: 'SQL Dialect';
		description: 'Defines the target SQL platform.';
		target: MocoSettings;
		parent: #moco;
		domainValues: #(#'PostgreSQL' #'Oracle' "#'MySQL'")
]
