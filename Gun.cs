using Godot;
using System;

public partial class Gun : RigidBody2D
{
  public Player PlayerOwner { get; private set; } = null;
  [Export]
  public float HoldDistance = 1.0f;
  private Sprite2D Sprite;
  public RayCast2D Shooty;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
    Sprite = GetNodeOrNull<Sprite2D>("Sprite2D");
    Shooty = GetNodeOrNull<RayCast2D>("Shooty");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

  public void PickUp(Player player) {
    PlayerOwner = player;
    Freeze = true;
    FreezeMode = RigidBody2D.FreezeModeEnum.Kinematic;
    Reparent(player.GunAnchor);
    Position = Vector2.Zero;
    Rotation = 0;
  }

  public void Drop() {
    Reparent(GetTree().CurrentScene);
    Freeze = false;
    PlayerOwner = null;
  }

  public bool IsHeldBy(Player player) {
    return PlayerOwner == player;
  }
}
