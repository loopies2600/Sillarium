extends Resource
class_name RangedWeapon

export (PackedScene) var projectile
export (Array, SpriteFrames) var aimGraphics

export (Array, Vector2) var projectileOffset

export (bool) var canRotate = true
export (bool) var hasCooldown = true
export (bool) var displayFlash = false

export (float, 0, 1) var aimWeight = 0.875
export (float, 0, 1) var cooldown = 0.25
export (float) var recoil = 0.0
