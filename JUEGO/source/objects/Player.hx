package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.math.FlxPoint;
// import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import utils.ActionFrame;

class Player extends FlxSprite {
  var maxVelocityX: Int = 150;
  var maxVelocityY: Int = 250;
  var accelX: Int = 2500;
  var deceleration: Int = 3000;
  var gravity: Int = 750;
  var jump: Int = 300;
  var actionFrameCounter: Int = 0;
  // public var SEPARATE_BIAS = 10;
  public var actionFrames: Array<ActionFrame>;
  public var init_pos: FlxPoint;
  public var clonesAvailable: Int = 0;
  public var isControllable: Bool = true;
  public var isClone: Bool;
  public var isLast: Bool = false;
  public var inLastFrame: Bool = false;

  override public function new(x: Float, y: Float, ?isClone: Bool = false) {
    super(x, y);
    this.isClone = isClone;
    init_pos = new FlxPoint(x, y);
    actionFrames = new Array<ActionFrame>();

    if (isClone) isControllable = false;

    // loadGraphic(AssetsPaths.imagen__png, true, 32, 32);
    createAnimations();
    setPhysicsProperties();
  }

  override public function update(elapsed: Float) {
    if (isClone) {
      super.update(elapsed);
      updateActionFrame();
      return;
    }

    if (isControllable) {
      checkInputs();
      if (alive) checkAnimations();
      super.update(elapsed);
      if (!isLast) addActionFrame();
    }
    checkCollisionFloor();
  }

  // Sets some physic properties of the player
  public function setPhysicsProperties() {
    // Adjust hitbox
    offset.set(6, 0);
    width = 20;
    height = 32;

    // Vertical gravity
    acceleration.y = gravity;

    // Horizontal deceleration
    drag.x = deceleration;

    // Max velocity
    maxVelocity.set(maxVelocityX, maxVelocityY);

    // Solid object
    solid = true;
  }

  // Creates all the animations
  function createAnimations() {
    var cloneFile = '';
    if (isClone) cloneFile = '_clone';
    frames = FlxAtlasFrames.fromSparrow('assets/images/player$cloneFile.png', 'assets/images/player.xml');
    animation.add('stand', [0], 1, false);
    animation.add('walk', [1, 2], 10, true);
    animation.add('jump', [3], 1, false);
    // animation.add('fall', [2], 1, false);
    animation.add('dead', [4], 1, false);
    animation.play('stand');
  }

  // Handles input and moves the player, jumps and all that stuff
  function checkInputs() {
    // End if the player is a clone.
    if (isClone) return;

    var up = FlxG.keys.anyJustPressed([UP, W, SPACE]);
    // var down = FlxG.keys.anyPressed([DOWN, S]);
    var left = FlxG.keys.anyPressed([LEFT, A]);
    var right = FlxG.keys.anyPressed([RIGHT, D]);

    // Horizontal movement
    // Reset acceleration to 0 to stop the player if nothing is pressed.
    if (left) acceleration.x = -accelX;
    else if (right) acceleration.x = accelX;
    else acceleration.x = 0;

    // Vertical movement
    if (up && isTouching(FlxObject.FLOOR)) velocity.y = -jump;
  }

  // Handles animations depending on state.
  function checkAnimations() {
    if (velocity.y < 0) animation.play('jump');
    else if (velocity.y > 0) animation.play('stand');
    else if (velocity.x == 0) animation.play('stand');
    else if (velocity.x < 0 || velocity.x > 0) animation.play('walk');

    if (velocity.x < 0) {
      facing = FlxObject.LEFT;
      flipX = true;
    } else if (velocity.x > 0) {
      facing = FlxObject.RIGHT;
      flipX = false;
    }
  }

  // Checks if the player is colliding with the bottom and disables it gravity if so.
  function checkCollisionFloor() {
    if (isTouching(FlxObject.FLOOR)) acceleration.y = 0;
    else acceleration.y = gravity;
    // trace(acceleration.y);
  }

  // Adds an action frame to the list of actionFrames.
  // These include info about the position, animation and orientation of the sprite on
  // past frames.
  function addActionFrame() {
    var af: ActionFrame = {
      position: new FlxPoint(x, y),
      animationName: animation.name,
      animationFrame: animation.frameIndex,
      flipX: flipX
    };

    actionFrames.push(af);
  }

  // Reinitializes the action frames array
  public function resetActionFrames() {
    actionFrameCounter = 0;
    actionFrames = new Array<ActionFrame>();
  }

  // Handles action frames done by clones by setting the properties of the player to
  // the given settings by the actual action frame.
  function updateActionFrame() {
    if (actionFrameCounter < actionFrames.length) {
      var af = actionFrames[actionFrameCounter];

      x = af.position.x;
      y = af.position.y;
      animation.name = af.animationName;
      animation.frameIndex = af.animationFrame;
      flipX = af.flipX;

      actionFrameCounter++;
      if (actionFrameCounter == actionFrames.length - 1) inLastFrame = true;
    } else resetActionFrames();
    // } else actionFrames = null;
  }

  /**
    Plays the dead animation and returns true if the player doesn't have clones availables
    or false otherwise
  */
  public function dies(): Bool {
    animation.play('dead');
    offset.set(12, 0);
    width = 32;
    height = 20;
    // y += 12;
    if (canClone()) return false;

    alive = false;
    return true;
  }

  // Returns true if the are clones available
  public function canClone() return clonesAvailable > 0;
}