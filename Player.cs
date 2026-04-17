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
  public string AttackAction;
  [Export]
  public string UseAction;
  [Export]
  public Node2D GunAnchor;
  [Export]
  public PackedScene BloodParticles = null;

  public Vector2 LookDir = new Vector2(1.0f, 0.0f);
  public bool InputEnabled = true;

  public int PlayerNumber;
  private Gun HeldGun;

  private Sprite2D Sprite;

  [Signal]
  public delegate void WinSignalEventHandler(Player player);
  [Signal]
  public delegate void PickupSignalEventHandler(Player player);

  public override void _Ready() {
    Sprite = GetNodeOrNull<Sprite2D>("Sprite2D");
    GunAnchor = GetNodeOrNull<Node2D>("GunAnchor");
    GD.PrintErr($"gun: {HeldGun}");

    WinSignal += GetParent<Game>().RegisterWinner;
    PickupSignal += GetParent<Game>().TryPickUpObject;
  }

  public void Initialize(int playerNumber, Gun theGun) {
    LeftAction = $"p{playerNumber}_left";
    RightAction = $"p{playerNumber}_right";
    AttackAction = $"p{playerNumber}_shoot";
    JumpAction = $"p{playerNumber}_jump";
    UseAction = $"p{playerNumber}_use";
    PlayerNumber = playerNumber;
  }

	public override void _PhysicsProcess(double delta) {
		Vector2 velocity = Velocity;

		// Add the gravity.
		if (!IsOnFloor()) {
			velocity += GetGravity() * GravityFactor * (float)delta;
		}

    float dirX = 0;
    if (InputEnabled) {
      // Handle Jump.
      if (Input.IsActionJustPressed("ui_accept") && IsOnFloor()) {
        velocity.Y = JumpVelocity;
      }

      dirX = Input.GetAxis(LeftAction, RightAction);
      if (dirX != 0) {
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
    if (InputEnabled) {
      if (e.IsActionPressed(JumpAction) && IsOnFloor()) {
        Vector2 velocity = new Vector2(Velocity.X, JumpVelocity);
        Velocity = velocity;
      }
      if (e.IsActionPressed(AttackAction)) {
        GD.Print("attack");
        TryAttack();
      }
      if (e.IsActionPressed(UseAction)) {
        GD.Print("use");
        EmitSignal(SignalName.PickupSignal, this);
      }
    }
  }

  public void TryPickUpGun(Gun gun) {
    Vector2 toGun = gun.GlobalPosition - GlobalPosition;
    GD.Print($"{toGun.Length()}");
    if (toGun.Length() <= 100.0f && toGun.Dot(LookDir) > 0) {
      HeldGun = gun;
      gun.MoveToPlayer(this);
    }
  }

  public void TryAttack() {
    if (HasGun()) {
      if (HeldGun.Shoot(this)) {
        EmitSignal(SignalName.WinSignal, this);
      }
    } else {
      // cast ray and see if it hits other player
      // if it does, knock them back and make them drop the gun
    }
  }

  public bool HasGun() {
    return HeldGun != null;
  }

  public void Bleed(Vector2 dir) {
    if (BloodParticles != null) {
      Blood blood = BloodParticles.Instantiate<Blood>();
      blood.SetDirection(dir);
      AddChild(blood);
    }
  }
}
