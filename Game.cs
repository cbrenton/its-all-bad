using Godot;
using System;
using System.Linq;

public partial class Game : Node2D
{
  [Export]
  public PackedScene PlayerScene;
  [Export]
  public Label WinLossLabel;

  private bool IsGameWon = false;
  private string GameWinner;

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
    if (Input.IsActionJustPressed("restart_game")) {
      GD.Print("restarting");
      StartGame();
    }
  }

  private void StartGame() {
    // TODO: delete any existing players
    // Filters only immediate children that are of type 'Weapon'
    var players = GetChildren().OfType<Player>().ToList();
    foreach (var player in players) {
      player.QueueFree();
    }

    for (int i = 1; i < 3; i++) {
      GD.Print($"spawning p{i}");
      Player player = PlayerScene.Instantiate<Player>();
      player.Position = new Vector2(249 + 600*(i - 1), 290);
      player.Initialize($"p{i}");
      player.CollisionLayer = (uint)i * 2;
      AddChild(player);
    }

    // TODO: hide win label
    WinLossLabel.Text = $"{GameWinner} wins!";
    WinLossLabel.Visible = !WinLossLabel.Visible;

    IsGameWon = false;
    GameWinner = null;
  }
}
