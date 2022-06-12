extends "res://addons/gut/test.gd"

var BearPlatform=load("res://screens/bear-village/assets/bear-platform.gd")

enum {IDLE,WALK,JUMP,JUMP_DOWN,HURT,DEAD}

func getBear():
	var bear=BearPlatform.new()
	return bear

func test_getStateIdleToIdleWithNoMoveOnFloor():
	
	var new_state=getBear().calculateNewState(IDLE,Vector2(0,0),true)
	
	var expectedState=IDLE
	assert_eq(expectedState,new_state,"idle to idle, on bouge pas")



func test_getStateIdleToWalkWithRightMoveOnFloor():
	
	var new_state=getBear().calculateNewState(IDLE,Vector2(2,0),true)

	var expectedState=WALK
	assert_eq(expectedState,new_state,"idle to walk, on bouge vers la droite")



func test_getStateWalkToIdleWithNoMoveOnFloor():
	
	var new_state=getBear().calculateNewState(WALK,Vector2(0,0),true)

	var expectedState=IDLE
	assert_eq(expectedState,new_state,"walk to idle, on bougeait, on bouge plus")




