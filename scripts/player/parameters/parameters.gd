extends Resource
class_name PlayerStats

export (Texture) var dashTexture

export (int) var health = 10
export (float) var maxSpeed = 200.0
export (float) var airMaxSpeed = 300.0
export (float) var acceleration = 75.0
export (float) var friction = 0.69
export (float) var airFriction = 0.975
export (float) var jumpStrength = 150.0
export (float) var timeJumpApex = 0.4
export (float) var fallMultiplier = 1.5
export (float) var dashStrength = 500.0
export (float) var dashDuration = 0.2
export (float, 0, 1) var bounceOff = 0.75
export (float) var graceTime = 2.0
export (float) var comboTime = 4.0
