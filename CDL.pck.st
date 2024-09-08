'From Cuis7.1 [latest update: #6676] on 7 September 2024 at 11:23:14 pm'!
'Description '!
!provides: 'CDL' 1 17!
SystemOrganization addCategory: #CDL!


!classDefinition: #AssignmentModel category: #CDL!
Object subclass: #AssignmentModel
	instanceVariableNames: 'assignments index'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CDL'!
!classDefinition: 'AssignmentModel class' category: #CDL!
AssignmentModel class
	instanceVariableNames: ''!

!classDefinition: #AssignmentSet category: #CDL!
Object subclass: #AssignmentSet
	instanceVariableNames: 'alts'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CDL'!
!classDefinition: 'AssignmentSet class' category: #CDL!
AssignmentSet class
	instanceVariableNames: ''!

!classDefinition: #AssignmentMorph category: #CDL!
PluggableMorph subclass: #AssignmentMorph
	instanceVariableNames: 'assignment'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CDL'!
!classDefinition: 'AssignmentMorph class' category: #CDL!
AssignmentMorph class
	instanceVariableNames: ''!

!classDefinition: #AssignmentBrowser category: #CDL!
SystemWindow subclass: #AssignmentBrowser
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CDL'!
!classDefinition: 'AssignmentBrowser class' category: #CDL!
AssignmentBrowser class
	instanceVariableNames: ''!


!AssignmentModel methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 22:25:40'!
assignments: anAssignmentSet

	assignments := anAssignmentSet invert asOrderedCollection.
	
	assignments notEmpty ifTrue:[self index: 1].! !

!AssignmentModel methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:53:50'!
currentAssignment

	index isNil ifTrue:[^{}].
	
	index = 0 ifTrue:[^{}].
	
	^assignments at: index! !

!AssignmentModel methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:45:37'!
index
	^index! !

!AssignmentModel methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 22:10:43'!
index: anInteger

	index := anInteger.
	
	self changed: #index
	! !

!AssignmentModel methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:37:09'!
indices
	^ (1 to: assignments size)! !

!AssignmentModel methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:46:36'!
initialize

	index := 0! !

!AssignmentSet methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 16:00:14'!
alts
	^alts! !

!AssignmentSet methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 16:00:50'!
alts: aSet
	alts := aSet! !

!AssignmentSet methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:41:00'!
invert

	^alts collect:[:each | self invert: each ]! !

!AssignmentSet methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:40:05'!
invert: aSet

	| reject |
	
	reject := Set new.
	
	1 to: 6 do:[:day | 1 to:22 do:[:hour | reject add: { day . hour } ] ].
	
	^(reject difference: aSet).
! !

!AssignmentSet methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 19:56:46'!
or: anAssignment

	| aSet |
	
	aSet := Set new.
	
	aSet addAll: alts ; addAll: anAssignment alts.
	
	^AssignmentSet new alts: aSet ; yourself! !

!AssignmentSet methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 19:56:46'!
union: anAssignment

	| result |
	
	result := Set new.
	
	alts do:[:left |
		anAssignment alts do:[:right |
			result add: (left union: right) ] ].
	
	^AssignmentSet new alts: result ; yourself.! !

!AssignmentSet class methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 23:15:58'!
choose: nDays fromHour: b toHour: e

	| alts days |

	alts := Set new.

	days := (1 to:6) choose: nDays.
	
	days do:[: each | | aSet |
		
		aSet := Set new.
		each do:[:d |			(b to: e - 1) do:[:h | aSet add: { d . h } ] ].
		alts add: aSet			 
	].
	
	^self new alts: alts ; yourself! !

!AssignmentSet class methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 16:18:04'!
empty
	
	^self new alts: (Set with: Set new) ; yourself! !

!AssignmentSet class methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 16:25:03'!
forDay: d fromHour: b toHour: e

	| aSet |
	
	aSet := Set new.
	
	(b to: e - 1) do:[:h | aSet add: { d . h } ].
	
	^self new alts: (Set with: aSet) ; yourself! !

!AssignmentSet class methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 16:25:15'!
fromDay: first toDay:last fromHour: b toHour: e

	| aSet |

	aSet := Set new.

	(first to:last) do:[:d |	
			(b to: e - 1) do:[:h | aSet add: { d . h } ] ].
	
	^self new alts: (Set with: aSet) ; yourself! !

!AssignmentMorph methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:53:31'!
drawOn: aCanvas

	| w h b e  |
	
	b := 8. e := 23.
	
	w := self localBounds width / 8.
	
	h := self localBounds height / (e-b+3).

	" the headers "
			
	1 to: 6 do:[:i |
		aCanvas  drawString: i asString atCenterX: (i +1) * w @ h font: FontFamily defaultFamilyAndPointSize color: Color black
		].
	
	b to: e do:[:j |
		aCanvas  drawString: j asString atWaistRight: w @ ((j - b + 2) * h) font: FontFamily defaultFamilyAndPointSize color: Color black	
		].

	" the grid "
	
	1 to: 7 do:[:i |
		aCanvas line: ((i+0.5)*w) @ (2*h) to: ((i+0.5)*w) @ ((e-b+2)*h) width: 1 color: (Color lightBlue).
		].
	
	1 to: e - b + 1 do:[:j |
		aCanvas  line: ((1.5)*w) @ ((j+1)*h) to: ((7.5)*w) @ ((j+1)*h)  width:1 color: Color lightBlue.
	].

	" the rejected slots "
	
	model ifNil: [^self].
	
	model currentAssignment do:[:each | | day hour |
		day := each first. hour := each second.
		hour >= b ifTrue:[
			aCanvas fillRectangle: ((((day + 0.5) * w) @ ((hour - b + 2) * h) extent: w@h) insetBy:2)  color: (Color h:0.0 s:0.17 v:1.0). ]
		].! !

!AssignmentMorph methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 21:50:20'!
initialize

	super initialize.
	
	color := Color white.
	
! !

!AssignmentMorph methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 22:11:23'!
update: anObject

	self redrawNeeded ! !

!AssignmentBrowser methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 22:15:31'!
buildMorphicWindow

	| p a m |
	
	p := PluggableListMorph withModel: model listGetter: #indices indexGetter: #index indexSetter:#index:.

	a := AssignmentMorph new model: model ; yourself.

	m := (a | 1.0 p - 1.0 p) + (p | 1.0 p - 64 f).
	
	self addMorph: m.
	
	self setLabel: 'Assignment Browser'.! !

!AssignmentBrowser class methodsFor: 'as yet unclassified' stamp: 'DF 9/7/2024 22:18:36'!
onAssignmentSet: anAssignmentSet

	| m | 
	
	m := AssignmentModel new.

	m assignments: anAssignmentSet .

	AssignmentBrowser open:m.! !

!SequenceableCollection methodsFor: '*CDL' stamp: 'DF 9/7/2024 23:08:05'!
choose: n

	| rest |
	
	self assert: n <= self size.
	
	n = 0 ifTrue:[^{{}}].

	n = self size ifTrue:[	^{ self copy } ].
	
	rest := self allButFirst.
	
	^(rest choose: n) ,  (rest choose: n - 1 :: collect:[:each | { self first } , each ] )
! !
