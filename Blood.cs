using Godot;
using System;

public partial class Blood : GpuParticles2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
    Emitting = true;
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

  public void SetDirection(Vector2 dir) {
    var mat = (ParticleProcessMaterial)ProcessMaterial;
    mat.Direction = new Vector3(dir.X, dir.Y, 0);
  }
}
