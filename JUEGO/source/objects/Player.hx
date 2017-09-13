package objects;

import flixel.FlxSprite;
import utils.ActionFrames;

class Player extends FlxSprite {
  public var isClone: Bool = false;
  private var actionFrames: ActionFrames;

  override public new(x: Float, y: Float) {
    super.new(x, y);
  }
}