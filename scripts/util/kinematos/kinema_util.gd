extends KinematicBody2D
class_name Kinematos

# warning-ignore:unused_signal
signal camera_shake_requested(mode, time, amp)
signal grounded_updated(isGrounded)
signal gravity_updated(doinGravity)

var inputSuffix := ""

var canInput := true setget _setInput
var displayTrails := false
var flashing := false
var applyGravity := true setget _doGravity
var isGrounded := true

export (NodePath) var nAnimator
export (NodePath) var nCollisionBox
export (NodePath) var nMainSprite

export (float) var acceleration
export (float) var deceleration
export (float) var jumpStrength
export (float) var maxSpeed
export (float) var fallMultiplier = 1.0
export (float) var friction = 1.0
export (Vector2) var snapVector = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
export (float) var timeJumpApex = 1.0
export (float) var bounciness = 0.9

var jumpForce := 0.0
var lastGoodPosition := Vector2()
var velocity := Vector2()

onready var animator = get_node(nAnimator)
onready var collisionBox = get_node(nCollisionBox)
onready var mainSprite = get_node(nMainSprite)

func setProcessing(booly : bool):
	set_process(booly)
	set_physics_process(booly)
	set_process_input(booly)
	set_process_unhandled_input(booly)
	set_process_unhandled_key_input(booly)
	
func _process(_delta):
	loop()
	
func _physics_process(delta):
	groundCheck()
	doGravity(delta)
	mainMotion(delta)
	
func loop():
	if flashing:
		visible = Renderer.flicker
	else:
		visible = true
	
func mainMotion(_delta):
	velocity.y = move_and_slide_with_snap(velocity, snapVector, Globals.UP, true).y
	
func doGravity(delta):
	var gravity
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	
	jumpForce = gravity * timeJumpApex
	
	if applyGravity:
		velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
	
func groundCheck():
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	
	if wasGrounded == null || isGrounded != wasGrounded:
		emit_signal("grounded_updated", isGrounded)
		lastGoodPosition = position
	
func _doGravity(booly : bool) -> void:
	applyGravity = booly
	emit_signal("gravity_updated", applyGravity)
	
func checkPushables(vel = velocity.x):
	var isOnEnvironment = false
	var pushable
	
	for b in get_slide_count():
		var body = get_slide_collision(b).collider
		
		if body:
			if body.is_in_group("Pushable"):
				pushable = body
			elif body.is_in_group("Environment"):
				isOnEnvironment = true
			
	if isOnEnvironment && pushable:
		pushable.Push(vel)
		
func setCollisionBits(bitArray := [], booly := true):
	for bit in bitArray:
		set_collision_mask_bit(bit, booly)

func keepOnScreen(clampX := true, clampY := false, offset := Vector2()):
	var ctrans = get_canvas_transform()

	var minPos = -ctrans.get_origin() / ctrans.get_scale()

	var viewSize = get_viewport_rect().size / ctrans.get_scale()
	var maxPos = minPos + viewSize
	
	if clampX:
		global_position.x = clamp(global_position.x, minPos.x + offset.x, maxPos.x - offset.x)
	if clampY:
		global_position.y = clamp(global_position.y, minPos.y + offset.y, maxPos.y - offset.y)

func placeOutOfScreen(side := -1, offset := 128):
	var ctrans = get_canvas_transform()
	
	var minPos = -ctrans.get_origin() / ctrans.get_scale()
	
	var viewSize = get_viewport_rect().size / ctrans.get_scale()
	
	var maxPos = minPos + (viewSize / 2)
	
	global_position.x = (maxPos.x * side) + (offset * side)
	
func getStandingTile(feetPos, tileMap := Objects.currentWorld.tileMap):
	var curTilePos = tileMap.world_to_map(feetPos)
	var curTile = tileMap.get_cellv(Vector2(curTilePos.x, curTilePos.y + 1))
	
	return curTile
	
func getShaderParam(parameter : String):
	var material = self.get_material()
	return material.get_shader_param(parameter)
	
func setupProperties(res : Resource, pStart := 8, pEnd := 0):
	var resPCount = res.get_property_list().size()
	
	for v in range(pStart, resPCount if pEnd == 0 else pEnd):
		var curP = res.get_property_list()[v].name
		
		set(curP, res.get(curP))
	
func getInputDirection(suffix := inputSuffix) -> int:
	if canInput:
		var inputDirection = Input.get_action_strength("move_right" + suffix) - Input.get_action_strength("move_left" + suffix)
		
		if inputDirection:
			flipGraphics(inputDirection)
		
		return inputDirection
		
	return 0
	
func getInputAngle(suffix := inputSuffix) -> Vector2:
	if canInput:
		var direction = Vector2(
			int(Input.get_action_strength("aim_right" + suffix)) - int(Input.get_action_strength("aim_left" + suffix)),
			int(Input.get_action_strength("aim_down" + suffix)) - int(Input.get_action_strength("aim_up" + suffix)))
			
		return direction
		
	return Vector2.ZERO
	
func getFacingDirection(spr := mainSprite):
	var facingDirection = spr.scale.x
	return facingDirection
	
func animspeedAsVelocity():
	if getInputDirection():
		animator.playback_speed = velocity.x / maxSpeed
	else:
		animator.playback_speed = 1
	
func playRandomAnim(anims : Array):
	randomize()
	var animToPlay = randi() % anims.size()
	animator.play(anims[animToPlay])
	
func flipGraphics(facing, spr := mainSprite):
	spr.scale.x = facing
	
func move(speed := maxSpeed, direction := getInputDirection()):
	velocity.x = clamp(velocity.x + (acceleration * direction), -speed, speed)
	
func decelerate(dec := deceleration, snap := 32):
	if abs(velocity.x) > snap:
		velocity.x -= dec * sign(velocity.x)
	else:
		velocity.x = 0
	
func trails(sprites = [mainSprite], color = "random"):
	if !displayTrails:
		return
	
	for spr in sprites:
		Renderer.spawnTrail(0.1, spr, color)
		
func _setInput(booly : bool):
	canInput = booly
	
func disableCollisionBox():
	collisionBox.set_deferred("disabled", true)
	
func renderShadow(node = self, shadow = get_node("Shadow")):
	var shadowSprites = Renderer.generateShadows(node)
	
	for sprite in shadowSprites:
		var newShadow = Sprite.new()
		newShadow.set_script(preload("res://scripts/util/sprite_sync.gd"))
		newShadow.target = sprite
		newShadow.use_parent_material = true
		shadow.add_child(newShadow)
