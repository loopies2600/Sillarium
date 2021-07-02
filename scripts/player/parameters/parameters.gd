extends Resource
class_name PlayerStats

export (int) var health = 10
export (float) var maxSpeed = 256.0
export (float) var airMaxSpeed = 320.0
export (float) var acceleration = 16.0
export (float) var deceleration = 32.0
export (float) var airDeceleration = 4.0
export (float) var jumpStrength = 150.0
export (float) var timeJumpApex = 0.4
export (float) var fallMultiplier = 1.5
export (float) var dashStrength = 960.0
export (float) var jumpCut = 128.0
export (float) var dashDuration = 0.2
export (float, 0, 1) var bounciness = 0.75
export (float) var graceTime = 2.0
export (float) var comboTime = 4.0
export (float) var respawnTime = 2.0

export (Array, Texture) var armsTextures
