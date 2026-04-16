using Godot;
using System;

public partial class Gun : RigidBody2D
{
  public Player PlayerOwner { get; private set; } = null;
  [Export]
  public float HoldDistance = 1.0f;
  [Export]
  public double FireRate = 0.5f;
  public RayCast2D Shooty;
  private Sprite2D Sprite;
  private double FireCooldown;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
    Sprite = GetNodeOrNull<Sprite2D>("Sprite2D");
    Shooty = GetNodeOrNull<RayCast2D>("Shooty");
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
    FireCooldown -= delta;
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

  public void Shoot(Player shooter) {
    if (FireCooldown < 0.0f) {
      if (Shooty.IsColliding()) {
        var other = Shooty.GetCollider();
        if (other is Player hitNode) {
          GD.Print($"hit node: {hitNode.Name}");
          shooter.EmitSignal(Player.SignalName.WinSignal, 1);
        }
      }
      AudioStreamPlayer2D gunshot = GetNodeOrNull<AudioStreamPlayer2D>("GunshotStream");
      gunshot.Play();
      if (gunshot == null) {
        GD.Print("null gunshot");
        return;
      }
      GD.Print($"bam! {FireCooldown} {gunshot}");
      FireCooldown = FireRate;
    } else {
      GD.Print($"click {FireCooldown}");
    }
  }
}
