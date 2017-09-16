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
	var PLAYER_INIT_POS: FlxPoint;
	var playerClones: FlxTypedSpriteGroup<Player>;
	var player: Player;
	var floor: FlxSprite;

	override public function create(): Void {
		super.create();
		PLAYER_INIT_POS = new FlxPoint(50, FlxG.height - 64);
		bgColor = FlxColor.fromString('#111111');

		createPlayer();
		createPlaceholderFloor();
		createPlayerClones();
	}

	override public function update(elapsed: Float): Void {
		// TODO: Add check canClone
		// check if clone is last, so it doesn't keep track of action frames to save memory
		// Move logic to Player if possible
		// if collidingBottom accel.y = 0 else accel.y = -gravity
		if (FlxG.keys.justPressed.R) {
			if (playerClones.countDead() > 0) {
				var clone: Player = playerClones.getFirstDead();
				// clone = new Player(player.init_pos.x, player.init_pos.y, true);
				clone.actionFrames = player.actionFrames;
				// Set the animation of the last action frame to idle to avoid awkardness
				// unless the animation currently playing is 'dead'
				var lastAF = clone.actionFrames[clone.actionFrames.length - 1];
				if (lastAF.animationName != 'dead') {
					lastAF.animationName = 'stand';
					lastAF.animationFrame = 0;
				}
				clone.revive();
				player.kill();
				player.reset(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y);
				// spawnPlayer();
				player.resetActionFrames();
			}
		}

		// There's a bug in the collision system for object separation.
		// Stacking objects will make them squeeze into one another.
		// A workaround is to check for collisions multiple times.
		// This is extremely unefficient, but works for now for at least 7 objects.
		checkCollisions();
		checkCollisions();
		checkCollisions();
		checkCollisions();
		checkCollisions();
		checkCollisions();

		super.update(elapsed);
	}

	function checkCollisions() {
		FlxG.collide(floor, player);
		FlxG.collide(floor, playerClones);
		FlxG.collide(player, playerClones);
		FlxG.collide(playerClones, playerClones);
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
		floor.solid = true;
		add(floor);
	}

	// Instantiates a Player and assigns it to player on the given position
	function spawnPlayer() player = new Player(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y);
}
