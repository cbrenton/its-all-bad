using Godot;
using System;
using System.Linq;

public partial class Game : Node2D
{
  [Export]
  public PackedScene PlayerScene;
  [Export]
  public PackedScene GunScene;
  [Export]
  public Label WinLossLabel;
  [Export]
  public ColorRect BlackLayer;

  private bool IsGameWon = false;
  private Random Rand = new Random();
  private Tween FadeTween;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
    StartGame();
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}

  public override void _Input(InputEvent e) {
    if (IsGameWon) {
      if (Input.IsActionJustPressed("restart_game")) {
        GD.Print("restarting");
        StartGame();
      }
    }
  }

  private void StartGame() {
    // Delete any active Players or Guns
    var players = GetChildren().OfType<Player>().ToList();
    foreach (var player in players) {
      player.QueueFree();
    }
    var guns = GetChildren().OfType<Gun>().ToList();
    foreach (var existingGun in guns) {
      existingGun.QueueFree();
    }

    // spawn gun
    Gun gun = GunScene.Instantiate<Gun>();
    gun.Position = new Vector2(577, 0);
    AddChild(gun);
    int sign = Rand.Next(0, 2) == 0 ? -1 : 1;
    gun.ApplyCentralImpulse(new Vector2(sign * Rand.Next(100, 200), 100));

    // spawn players
    for (int i = 1; i < 3; i++) {
      GD.Print($"spawning p{i}");
      Player player = PlayerScene.Instantiate<Player>();
      player.Position = new Vector2(249 + 600*(i - 1), 290);
      player.Initialize(i, gun);
      player.CollisionLayer = (uint)i * 2;
      player.Name = $"Player{i}";
      AddChild(player);
    }

    WinLossLabel.Visible = false;

    IsGameWon = false;

    FadeTween.Kill();
    BlackLayer.Modulate = new Color(0, 0, 0, 0);
  }

  public void RegisterWinner(Player winner) {
    WinLossLabel.Text = $"Player {winner.PlayerNumber} wins!";
    WinLossLabel.Visible = true;

    IsGameWon = true;

    // freeze players
    var players = GetChildren().OfType<Player>().ToList();
    foreach (var player in players) {
      player.InputEnabled = false;
    }
    FadeToBlack();
  }

  public void TryPickUpObject(Player player) {
    GD.Print($"player {player.PlayerNumber} picking up");
    var guns = GetChildren().OfType<Gun>().ToList();
    // NOTE: if you add multiple guns you should probably change this to only grab the closest one
    foreach (var existingGun in guns) {
      player.TryPickUpGun(existingGun);
    }
  }

  public void FadeToBlack() {
    FadeTween = CreateTween();
    FadeTween.TweenProperty(BlackLayer, "modulate:a", 1.0, 2.0);
  }
}
