using Godot;
using System;

public partial class Camera : Camera2D
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

  public async void Shake(float duration = 0.3f, float strength = 10f) {
    float elapsed = 0f;
    while (elapsed < duration) {
      float remainingRatio = 1f - (elapsed / duration);
      Offset = new Vector2(
        (float)GD.RandRange(-strength, strength) * remainingRatio,
        (float)GD.RandRange(-strength, strength) * remainingRatio
      );
      elapsed += (float)GetProcessDeltaTime();
      await ToSignal(GetTree(), SceneTree.SignalName.ProcessFrame);
    }
    Offset = Vector2.Zero;
  }
}
