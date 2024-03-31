"
Provides user-configurable settings.
"
Class {
	#name : #MocoSettings,
	#superclass : #Object,
	#classVars : [
		'openMode'
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

{ #category : #settings }
MocoSettings class >> settingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #moco)
		label: 'Moco';
		description: 'OntoUML to SQL transformation settings.'
]
