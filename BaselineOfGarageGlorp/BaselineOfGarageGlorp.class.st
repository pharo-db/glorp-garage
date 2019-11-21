Class {
	#name : #BaselineOfGarageGlorp,
	#superclass : #BaselineOf,
	#category : 'BaselineOfGarageGlorp'
}

{ #category : #baselines }
BaselineOfGarageGlorp >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec package: 'GarageGlorpDriver' ].

]
