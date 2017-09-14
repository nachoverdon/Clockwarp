package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import utils.ActionFrame;

class Player extends FlxSprite {
  var maxVelocityX: Int = 150;
  var maxVelocityY: Int = 250;
  var accelX: Int = 2500;
  var deceleration: Int = 3000;
  var gravity: Int = 700;
  var jump: Int = 200;
  var actionFrameCounter: Int = 0;
  public var SEPARATE_BIAS = 10;
  public var actionFrames: Array<ActionFrame>;
  public var init_pos: FlxPoint;
  public var clonesAvailable: Int = 0;
  public var isControllable: Bool = true;
  public var isClone: Bool;

  override public function new(x: Float, y: Float, ?isClone: Bool = false) {
    super(x, y);
    this.isClone = isClone;
    init_pos = new FlxPoint(x, y);
    actionFrames = new Array<ActionFrame>();

    if (isClone) {
      isControllable = false;
      makeGraphic(16, 16, FlxColor.GRAY);
    }

    // Physic properties
    // Vertical gravity
    acceleration.y = gravity;

    // Horizontal deceleration
    drag.x = deceleration;

    // Max velocity
    maxVelocity.set(maxVelocityX, maxVelocityY);

    // Solid object
    solid = true;

    // loadGraphic(AssetsPaths.imagen__png, true, 32, 32);
  }

  override public function update(elapsed: Float) {
    if (isControllable) checkInputs();
    if (isClone) {
      updateActionFrame();
      super.update(elapsed);
      return;
    }
    super.update(elapsed);
    addActionFrame();
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
    // TODO: Check if the player is on the floor
    if (up) velocity.y = -jump;
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
    } else resetActionFrames();
  }

  // Returns true if the are clones available
  function canClone() return clonesAvailable > 0;
}