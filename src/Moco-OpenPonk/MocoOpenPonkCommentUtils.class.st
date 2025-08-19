"
Contains class transformation utilities.
"
Class {
	#name : 'MocoOpenPonkCommentUtils',
	#superclass : 'Object',
	#category : 'Moco-OpenPonk-Utils',
	#package : 'Moco-OpenPonk',
	#tag : 'Utils'
}

{ #category : 'accessing' }
MocoOpenPonkCommentUtils class >> addComment: aString to: anOPUMLClass [
	"Appends the given string as a comment of the given class."
	
	anOPUMLClass ownedComments
		ifEmpty: [
			| comment |
			comment := OPUMLComment new.
			comment body: aString.
			anOPUMLClass ownedComments add: comment
		]
		ifNotEmpty: [ 
			| comment |
			comment := anOPUMLClass ownedComments last.
			comment body: ((comment body) , (Character cr asString) , (Character cr asString) , aString)
		]
]
