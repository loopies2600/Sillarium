using Godot;
using System;

public class Trail : Sprite
{
    public float fadeSpeed = 0.1f;
    public float life = 1.0f;
    public Color color = new Color(1f, 0.5f, 1f, 1f);

    public override void _Ready()
    {
        Material = (Godot.Material) Material.Duplicate();
        (Material as ShaderMaterial).SetShaderParam("flash_color", color);
    }

    public override void _Process(float delta)
    {
        
    }
}
