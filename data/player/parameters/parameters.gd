extends Resource
class_name PlayerStats

export (float) var maxSpeed = 400.0
export (float) var acceleration = 200.0
export (float) var friction = 200.0
export (float) var jumpStrength = 150.0
export (float) var timeJumpApex = 0.4
export (float) var fallMultiplier = 1.5
export (float) var dashStrength = 1000.0
export (float) var cameraOffset = 1.5
export (float, 0, 1) var aimWeight = 0.5

export (Array, AtlasTexture) var headTextures
export (Texture) var playerNumberTexture
