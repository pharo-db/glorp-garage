"
I am a Glorp driver that interfaces against Garage drivers. In such way, this driver allows glorp to use multiple databases with the same API.

My glorp-API protocol contains methods that forward messages to the garage driver.
My private protocol contains methods that convert glorp Login objects into garage connection strings.

I am configurable with a driver manager to be able to check which is the best driver to use depending on the installed drivers.
"
Class {
	#name : #GAGlorpDriver,
	#superclass : #DatabaseDriver,
	#instVars : [
		'driverManager',
		'lastResult'
	],
	#category : 'GarageGlorpDriver'
}

{ #category : #configuration }
GAGlorpDriver class >> beGlorpDefaultDriver [
	"Install this as default driver for Glorp in Pharo"

	PharoDatabaseAccessor DefaultDriver: self
]

{ #category : #private }
GAGlorpDriver >> addPasswordOf: aLogin to: options [
	aLogin secure
		ifTrue:
			[ | secure |
			secure := aLogin secure.
			[ aLogin secure: false.
			aLogin password isEmptyOrNil
				ifFalse: [ options add: 'password=' , aLogin password ] ]
				ensure: [ aLogin secure: secure ] ]
		ifFalse: [ 
			aLogin password isEmptyOrNil
				ifFalse: [ options add: 'password=' , aLogin password ]
			]
]

{ #category : #'glorp-API' }
GAGlorpDriver >> basicExecuteSQLString: aString [

	lastResult := connection execute: aString.
	lastResult isResultSet ifTrue: [ ^ lastResult rows readStream ].
	^ #() readStream
]

{ #category : #'glorp-API' }
GAGlorpDriver >> basicExecuteSQLString: aString binding: aBindingArray [

	| preparedStatement |
	preparedStatement := connection prepare: aString.
	aBindingArray doWithIndex: [ :arg :i|  preparedStatement at: i bind: arg].
	lastResult := preparedStatement execute.
	lastResult isResultSet ifTrue: [ ^ lastResult rows readStream ].
	^ #() readStream
]

{ #category : #private }
GAGlorpDriver >> basicSchemaForLogin: aLogin [

	aLogin platform isMySQLPlatform ifTrue: [ ^'mysql' ].
	aLogin platform isPostgreSQLPlatform ifTrue: [ ^ 'postgresV2' ].
	aLogin platform isSQLite3Platform ifTrue: [ ^ 'sqlite3' ].
	self error: 'The Garage Glorp driver does not yet support to connect to Glorp platform: ', aLogin platform class name
]

{ #category : #'glorp-API' }
GAGlorpDriver >> beginTransaction [

	connection beginTransaction
]

{ #category : #'glorp-API' }
GAGlorpDriver >> commitTransaction [

	connection commitTransaction
]

{ #category : #'glorp-API' }
GAGlorpDriver >> connect: aLogin [

	^ connection := GADriver connectToConnectionString: (self connectionStringForLogin: aLogin)
]

{ #category : #private }
GAGlorpDriver >> connectionStringForLogin: aLogin [
	| schema host port database options |
	schema := self schemaForLogin: aLogin.
	host := aLogin host.
	port := aLogin port isEmptyOrNil
		ifTrue: ''
		ifFalse: [ ':' , aLogin port ].
	database := aLogin databaseName.
	schema = 'sqlite3'
		ifTrue: [ ^ schema , '://' , host , database ].
	options := OrderedCollection new.
	aLogin username isEmptyOrNil
		ifFalse: [ options add: 'user=' , aLogin username ].
	self addPasswordOf: aLogin to: options.
	schema = 'opendbx'
		ifTrue: [ options
				add: 'backend=' , (self basicSchemaForLogin: aLogin) ].
	^ schema , '://' , host , port , '/' , database
		, (options ifNotEmpty: [ '?' , (options joinUsing: '&') ])
]

{ #category : #accessing }
GAGlorpDriver >> driverManager [
	^ driverManager ifNil: [ GADriver ]
]

{ #category : #accessing }
GAGlorpDriver >> driverManager: aGADriverManager [ 
	
	driverManager := aGADriverManager
]

{ #category : #'glorp-API' }
GAGlorpDriver >> isConnected [

	^ connection notNil and: [connection isConnected]
]

{ #category : #'glorp-API' }
GAGlorpDriver >> logout [

	connection close
]

{ #category : #'glorp-API' }
GAGlorpDriver >> rollbackTransaction [

	connection rollbackTransaction
]

{ #category : #'glorp-API' }
GAGlorpDriver >> rowCount [

	lastResult isResultSet ifTrue: [ ^ lastResult rows size ].
	^lastResult affectedRows
]

{ #category : #private }
GAGlorpDriver >> schemaForLogin: aLogin [

	| schema |
	schema := (self basicSchemaForLogin: aLogin) asSymbol.
	(self driverManager isAvailable: schema) ifTrue: [ ^ schema ].
	(self driverManager isAvailable: #opendbx) ifTrue: [ ^ #opendbx ].
	self error: 'no Garage driver is available for login: ', aLogin asString.
]
