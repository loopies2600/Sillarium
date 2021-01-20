extends Resource
class_name RangedWeapon

export (PackedScene) var projectile
export (Texture) var texture

export (Vector2) var projectileOffset = Vector2(0, 0)
export (Vector2) var muzzleOffset = Vector2(0, 0)

export (bool) var hasCooldown = true
export (bool) var displayFlash = false

export (float) var velocityReduction = 0.0
export (float) var cooldown = 0.0
export (float) var recoil = 0.0
