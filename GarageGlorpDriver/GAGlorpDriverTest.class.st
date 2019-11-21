Class {
	#name : #GAGlorpDriverTest,
	#superclass : #TestCase,
	#category : 'GarageGlorpDriver'
}

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForCompleteLogin [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		username: 'sodbxtest';
		password: 'sodbxtest';
		host: 'localhost';
      port: '3306';
		connectString: 'localhost_sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:3306/sodbxtest?user=sodbxtest&password=sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForLoginWithDatabaseInGlorpConnectionProperty [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		port: '5432';
		host: 'localhost';
		databaseName: 'sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:5432/sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForLoginWithHostInGlorpConnectionProperty [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		port: '5432';
		host: 'localhost';
		connectString: '_sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:5432/sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForLoginWithHostInGlorpConnectionString [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		port: '5432';
		connectString: 'localhost_sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:5432/sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForLoginWithoutOptions [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		port: '5432';
		host: 'localhost';
		connectString: 'localhost_sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:5432/sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForLoginWithoutPassword [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		username: 'sodbxtest';
		port: '5432';
		host: 'localhost';
		connectString: 'localhost_sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:5432/sodbxtest?user=sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForLoginWithoutPortHasDefaultPort5432 [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		username: 'sodbxtest';
		password: 'sodbxtest';
		host: 'localhost';
		connectString: 'localhost_sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:5432/sodbxtest?user=sodbxtest&password=sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testConnectionStringForLoginWithoutUsername [

	| driver login connectionString |
	driver := GAGlorpDriver new.
	login := (Login new)
		database: MySQLPlatform new;
		password: 'sodbxtest';
		port: '5432';
		host: 'localhost';
		connectString: 'localhost_sodbxtest'.
	connectionString := driver connectionStringForLogin: login.
	self assert: connectionString equals: 'mysql://localhost:5432/sodbxtest?password=sodbxtest'
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testSchemaForMysql [

	| driver login |
	driver := GAGlorpDriver new.
	login := Login new database: MySQLPlatform new.
	self assert: (driver schemaForLogin: login) equals: 'mysql'.
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testSchemaForOpenDBX [

	| driver login garageDriver |
	driver := GAGlorpDriver new.
	garageDriver := GAMockDriver withId: #opendbx.
	driver driverManager: (GADriverManager new subscribeDriver: garageDriver).
	login := Login new database: SQLite3Platform new.
	self assert: (driver schemaForLogin: login) equals: 'opendbx'.
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testSchemaForPostgresql [

	| driver login |
	driver := GAGlorpDriver new.
	login := Login new database: PostgreSQLPlatform new.
	self assert: (driver schemaForLogin: login) equals: 'postgresV2'.
]

{ #category : #'as yet unclassified' }
GAGlorpDriverTest >> testSchemaForSqlite3 [

	| driver login |
	driver := GAGlorpDriver new.
	login := Login new database: SQLite3Platform new.
	self assert: (driver schemaForLogin: login) equals: 'sqlite3'.
]
