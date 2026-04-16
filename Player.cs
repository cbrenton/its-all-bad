using Godot;
using System;

public partial class Player : CharacterBody2D
{
  [Export]
	public float Speed = 600.0f;
  [Export]
	public float JumpVelocity = -800.0f;
  [Export]
  public float GravityFactor = 1.3f;
  [Export]
  public string LeftAction;
  [Export]
  public string RightAction;
  [Export]
  public string JumpAction;
  [Export]
  public string ShootAction;
  [Export]
  public string UseAction;
  [Export]
  public Node2D GunAnchor;

  public Vector2 LookDir = new Vector2(1.0f, 0.0f);
  public bool InputEnabled = true;

  private Gun HeldGun;

  private Sprite2D Sprite;

  [Signal]
  public delegate void WinSignalEventHandler(int playerNumber);

  public override void _Ready() {
    Sprite = GetNodeOrNull<Sprite2D>("Sprite2D");
    GunAnchor = GetNodeOrNull<Node2D>("GunAnchor");
    GD.PrintErr($"gun: {HeldGun}");
    WinSignal += GetParent<Game>().RegisterWinner;
  }

  public void Initialize(int playerNumber, Gun theGun) {
    LeftAction = $"p{playerNumber}_left";
    RightAction = $"p{playerNumber}_right";
    ShootAction = $"p{playerNumber}_shoot";
    JumpAction = $"p{playerNumber}_jump";
    UseAction = $"p{playerNumber}_use";
    HeldGun = theGun;
  }

	public override void _PhysicsProcess(double delta) {
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor())
		{
			velocity += GetGravity() * GravityFactor * (float)delta;
		}

    float dirX = 0;
    if (InputEnabled) {
      // Handle Jump.
      if (Input.IsActionJustPressed("ui_accept") && IsOnFloor())
      {
        velocity.Y = JumpVelocity;
      }

      dirX = Input.GetAxis(LeftAction, RightAction);
      if (dirX != 0)
      {
        float sign = Mathf.Sign(dirX);
        LookDir = new Vector2(sign, 0);
        Sprite.FlipH = dirX < 0;
        GunAnchor.Scale = new Vector2(sign, 1);
        GunAnchor.Position = new Vector2(sign * 47.0f, -5.0f);
      }
    }
    velocity.X = Mathf.MoveToward(Velocity.X, dirX * Speed, Speed * (float)delta);

    Velocity = velocity;
    MoveAndSlide();
  }

  public override void _Input(InputEvent e) {
    if (e.IsActionPressed(JumpAction) && IsOnFloor()) {
      Vector2 velocity = new Vector2(Velocity.X, JumpVelocity);
      Velocity = velocity;
    }
    if (e.IsActionPressed(ShootAction)) {
      TryShoot();
    }
    if (e.IsActionPressed(UseAction)) {
      GD.Print("action taken");
      TryPickUpGun(HeldGun);
    }
  }

  public void TryPickUpGun(Gun gun) {
    GD.Print("trying to pick up gun");
    Vector2 toGun = HeldGun.GlobalPosition - GlobalPosition;
    GD.Print($"{toGun}");
    if (toGun.Length() <= 100.0f && toGun.Dot(LookDir) > 0) {
      GD.Print("picked up gun");
      gun.PickUp(this);
    }
    GD.Print("failed to pick up gun");
  }

  public void TryShoot() {
    if (HasGun()) {
      HeldGun.Shoot(this);
    } else {
      GD.Print("uhhhh nothing happened");
    }
  }

  public bool HasGun() {
    return HeldGun != null;
  }
}
