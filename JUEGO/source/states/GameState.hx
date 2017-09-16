package states;

import flixel.FlxG;
import flixel.FlxState;
// import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
// import flixel.tile.FlxTilemap;
import utils.TiledLevel;
import objects.*;

class GameState extends FlxState {
  // timer
	public var LEVEL_NAME: String;
  public var PLAYER_INIT_POS: FlxPoint;
	var playerClones: FlxTypedSpriteGroup<Player>;
	public var player: Player;
	var playerAndClones: FlxGroup;
	public var pickups: FlxTypedSpriteGroup<Pickup>;
	public var pickupAmount: Int = 0;
	public var pickedUp: Int = 0;
	// public var floor: FlxObject;
	// public var exit: FlxObject;
  public var door: Door;
	public var level: TiledLevel;
	// var floor: FlxSprite;
  public var buttons: FlxTypedSpriteGroup<Button>;
  public var platforms: FlxTypedSpriteGroup<Platform>; // FlxGroup;
	public var spikes: FlxTypedSpriteGroup<Spikes>;
	// UI controls text

	override public function create(): Void {
		super.create();
		PLAYER_INIT_POS = new FlxPoint(0, 0);
		bgColor = FlxColor.fromString('#111111');
		// TODO: Array of levels
		// levelCount: Int = 0;
		// onExit levelCount++
		// if levelCount > levels.length changeState(credits);
		spikes = new FlxTypedSpriteGroup<Spikes>();
		pickups = new FlxTypedSpriteGroup<Pickup>();
		buttons = new FlxTypedSpriteGroup<Button>();
		platforms = new FlxTypedSpriteGroup<Platform>(); // new FlxGroup();
		level = new TiledLevel('assets/tiled/$LEVEL_NAME.tmx', this);

		add(level.backgroundTilesLayer);
		add(pickups);
		add(level.backgroundImagesLayer);
		add(level.objectsLayer);
		createPlayer();
		createPlayerClones();
		playerAndClones = new FlxGroup();
		playerAndClones.add(player);
		playerAndClones.add(playerClones); // FlxTypeSpriteGroup<Player>();
		add(level.foregroundTilesLayer);
	}

	override public function update(elapsed: Float): Void {
		checkInputs();

		super.update(elapsed);

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

		checkOverlaps();
		checkPickedUp();
	}

	// Creates and spawns the player at the initial position.
	function createPlayer() {
		spawnPlayer();
		FlxG.camera.follow(player);
		add(player);
	}

	function createPlayerClones() {
		playerClones = new FlxTypedSpriteGroup<Player>(0, 0);
		for (i in 0...4) {
			var clone = new Player(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y, true);
			clone.kill();
			playerClones.add(clone);
		}
		add(playerClones);
	}

	// Instantiates a Player and assigns it to player on the given position
	function spawnPlayer() player = new Player(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y);

	// Checks for keyboard inputs
	function checkInputs() {
		if (FlxG.keys.justPressed.R) clonePlayer();
	}

	// Checks the collisions between different objects and/or group of objects
	function checkCollisions() {
		level.collideWithLevel(player);
		level.collideWithLevel(playerClones);
		if (platforms.length > 0) {
			for (plat in platforms) {
				level.collideWithLevel(plat);
			}
			FlxG.collide(playerAndClones, platforms);
		}
		if (playerClones.countLiving() > 0) FlxG.collide(playerAndClones, playerAndClones);
		// FlxG.collide(floor, player);
		// FlxG.collide(floor, playerClones);
		// FlxG.collide(playerClones, playerClones);
	}

	// Checks overlaping of different objects
	function checkOverlaps() {
		//FlxTilemap.overlaps();
		if (spikes.length > 0) FlxG.overlap(player, spikes, onSpiked);
		// TODO: make all buttons changeDirection if not press
		for (button in buttons) {
			button.isPressed = false;
		}
		FlxG.overlap(playerAndClones, buttons, onPress);
		if (!allPickedUp()) FlxG.overlap(playerAndClones, pickups, onPickup);
		if (door.isOpen) FlxG.overlap(playerAndClones, door, onExit);
	}

	// Checks if it's possible to clone the player and does it if so
	// TODO: Move logic to Player if possible
	function clonePlayer() {
		if (playerClones.countDead() > 0 && player.canClone()) {
				var clone: Player = playerClones.getFirstDead();
				// Check if is the last available clone or if there's no more pickups on the map,
				// so the player doesn't keep track of its action frames anymore to save memory.
				if (playerClones.countDead() == 0 || allPickedUp()) player.isLast = true;

				// clone = new Player(player.init_pos.x, player.init_pos.y, true);

				// Copies player action frames to the clone.
				clone.actionFrames = player.actionFrames;

				// Set the animation of the last action frame to idle to avoid awkardness
				// unless the animation currently playing is 'dead'
				if (clone.actionFrames != null) {
					var lastAFIndex = clone.actionFrames.length - 1;
					var lastAF = clone.actionFrames[lastAFIndex];

					if (lastAF.animationName != 'dead') {
						lastAF.animationName = 'stand';
						lastAF.animationFrame = 0;
					}

					// clone.actionFrames[lastAFIndex] = lastAF;
				}

				clone.revive();
				player.kill();
				player.reset(PLAYER_INIT_POS.x, PLAYER_INIT_POS.y);
				player.clonesAvailable--;
				// spawnPlayer();
				// Creates a new array of action frames.
				player.resetActionFrames();
			}
	}

	// Automatically makes the player clone himself and reappear
	function onSpiked(player: Player, spikes: Spikes) {
		// TODO: Improve
		player.animation.play('dead');
		if (player.canClone()) {
			clonePlayer();
		} else {
			// TODO:
			// [R]estart level
			player.isControllable = false;
			haxe.Timer.delay(FlxG.resetState, 2000); //ms
		}
	}

	// Makes the pickup disapear from screen and increases the amount of available clones
	// of the player
	function onPickup(player: Player, pickup: Pickup) {
		pickup.kill();
		player.clonesAvailable++;
	}

	// Makes the button play the pressed animation and makes the platform associated to the
	// buttons id move
	function onPress(player: Player, button: Button) {
		for (platform in platforms) {
			if (platform.id == button.id) platform.changeDirection();
		}
	}

	// Gets to the next level or to the ending credits
	function onExit(player: Player, door: Door) {
		// levels++
		// if (levelLists.length == level) state = credits
	}

	// Check if there are pickups available
	function allPickedUp(): Bool {
		return pickedUp == pickupAmount;
	}

	// Opens the exit door if all the pickups have been picked up.
	function checkPickedUp() {
		if (allPickedUp()) door.isOpen = true;
	}
}