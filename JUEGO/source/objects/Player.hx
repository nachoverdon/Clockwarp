package objects;

import flixel.FlxG;
import flixel.FlxSprite;
import utils.ActionFrames;

class Player extends FlxSprite {
  var maxVelocityX: Float = 150;
  var maxVelocityY: Float = 250;
  var accelX: Float = 1000;
  var deceleration: Float = 1200;
  var gravity: Float = 600;
  var jump: Float = 225;
  var actionFrames: ActionFrames;
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
  }

  // Handles input and moves the player, jumps and all that stuff
  private function checkInputs() {
    // End if the player is a clone.
    if (isClone) return;

    var up = FlxG.keys.anyJustPressed([UP, W]);
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
}