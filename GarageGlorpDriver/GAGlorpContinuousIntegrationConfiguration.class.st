Class {
	#name : #GAGlorpContinuousIntegrationConfiguration,
	#superclass : #Object,
	#category : 'GarageGlorpDriver'
}

{ #category : #private }
GAGlorpContinuousIntegrationConfiguration >> configureGlorpLoginResource: aLogin [

	GAGlorpDriver beGlorpDefaultDriver.
	GlorpDatabaseLoginResource current: nil.
	GlorpDatabaseLoginResource defaultLogin: aLogin
]

{ #category : #configuration }
GAGlorpContinuousIntegrationConfiguration >> configureMysql [

	self configureGlorpLoginResource: (Login new
		database: MySQLPlatform new;
		host: 'localhost';
		port: '3306';
		databaseName: 'sodbxtestglorp';
		username: 'sodbxtest';
		password: 'sodbxtest')
]

{ #category : #configuration }
GAGlorpContinuousIntegrationConfiguration >> configurePostgresql [

	self configureGlorpLoginResource: (Login new
		database: PostgreSQLPlatform new;
		host: 'localhost';
		port: '5432';
		databaseName: 'sodbxtestglorp';
		username: 'sodbxtest';
		password: 'sodbxtest')
]

{ #category : #configuration }
GAGlorpContinuousIntegrationConfiguration >> configureSqlite3 [

	self configureGlorpLoginResource: (Login new
		database: SQLite3Platform new;
		host: SmalltalkImage current imagePath asFileReference parent fullName, FileSystem disk delimiter asString;
		port: '';
		username: '';
		password: '';
		databaseName: 'sodbxtest.db')
]
