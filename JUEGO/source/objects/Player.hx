package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import utils.ActionFrame;

class Player extends FlxSprite {
  var maxVelocityX: Int = 150;
  var maxVelocityY: Int = 250;
  var accelX: Int = 2500;
  var deceleration: Int = 3000;
  var gravity: Int = 700;
  var jump: Int = 200;
  var actionFrames: Array<ActionFrame>;
  var controllable: Bool = true;
  var clonesAvailable: Int = 0;
  public var isClone: Bool = false;

  override public function new(x: Float, y: Float) {
    super(x, y);

    // Physic properties
    // Vertical gravity
    acceleration.y = gravity;

    // Horizontal deceleration
    drag.x = deceleration;

    // Max velocity
    maxVelocity.set(maxVelocityX, maxVelocityY);

    // loadGraphic(AssetsPaths.imagen__png, true, 32, 32);
  }

  override public function update(elapsed: Float) {
    checkInputs();
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
    //new ActionFrame(new FlxPoint(x, y), animation.name, animation.frameIndex, flipX)
    var af: ActionFrame = {
      position: new FlxPoint(x, y),
      animationName: animation.name,
      animationFrame: animation.frameIndex,
      flipX: flipX
    };

    actionFrames.push(af);
  }

  // Returns true if the are clones available
  function canClone() return clonesAvailable > 0;
}