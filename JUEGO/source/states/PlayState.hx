package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxSpriteGroup;
import objects.Player;

class PlayState extends FlxState
{
	static var PLAYER_INIT_POS: FlxPoint;
	var playerClones: FlxTypedSpriteGroup<Player>;
	var player: Player;
	var floor: FlxSprite;

	override public function create(): Void {
		super.create();
		PLAYER_INIT_POS = new FlxPoint(50, FlxG.height - 32);
		bgColor = FlxColor.fromString('#111111');

		createPlayer();
		createPlaceholderFloor();
		createPlayerClones();
	}

	override public function update(elapsed: Float): Void {

		// TODO: Add check canClone
		// Move logic to Player if possible
		if (FlxG.keys.justPressed.R) {
			if (playerClones.countDead() > 0) {
				var clone: Player = playerClones.getFirstDead();
				// clone = new Player(player.init_pos.x, player.init_pos.y, true);
				clone.actionFrames = player.actionFrames;
				clone.revive();
				player.kill();
				player.reset(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y);
				// spawnPlayer();
				player.resetActionFrames();
			}
		}

		FlxG.collide(floor, player);
		FlxG.collide(floor, playerClones);
		FlxG.collide(player, playerClones);
		FlxG.collide(playerClones, playerClones);

		super.update(elapsed);
	}

	// Creates and spawns the player at the initial position.
	function createPlayer() {
		spawnPlayer();
		add(player);
	}

	function createPlayerClones() {
		playerClones = new FlxTypedSpriteGroup<Player>(0, 0);
		for (i in 0...10) {
			var clone = new Player(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y, true);
			clone.kill();
			playerClones.add(clone);
		}
		add(playerClones);
	}

	// Creates a red bar that serves as a placeholder floor.
	function createPlaceholderFloor() {
		floor = new FlxSprite(0, FlxG.height - 10);
		floor.makeGraphic(FlxG.width, 10, FlxColor.RED);
		floor.immovable = true;
		add(floor);
	}

	// Instantiates a Player and assigns it to player on the given position
	function spawnPlayer() player = new Player(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y);
}
