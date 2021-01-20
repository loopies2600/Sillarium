extends Resource
class_name RangedWeapon

export (PackedScene) var projectile
export (Array, StreamTexture) var aimTextures

export (Array, Vector2) var projectileOffset

export (bool) var hasCooldown = true
export (bool) var displayFlash = false

export (float) var velocityReduction = 0.0
export (float) var cooldown = 0.0
export (float) var recoil = 0.0
