using Godot;
using System;

public class audio : Node
{
	public bool mute = false;
	
	public override void _Ready()
	{
		GD.Print("TEST"); 
	}
}
