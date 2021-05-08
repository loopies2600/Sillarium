extends Resource
class_name PlayerStats

export (int) var health = 10
export (float) var maxSpeed = 256.0
export (float) var airMaxSpeed = 320.0
export (float) var acceleration = 64.0
export (float) var friction = 0.69
export (float) var airFriction = 0.975
export (float) var jumpStrength = 150.0
export (float) var timeJumpApex = 0.4
export (float) var fallMultiplier = 1.5
export (float) var dashStrength = 24.0
export (float) var dashDuration = 0.2
export (float, 0, 1) var bounciness = 0.75
export (float) var graceTime = 2.0
export (float) var comboTime = 4.0
export (float) var respawnTime = 2.0

export (Array, Texture) var armsTextures
