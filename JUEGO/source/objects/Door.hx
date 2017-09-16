package objects;

import flixel.FlxSprite;

class Door extends FlxSprite {
  public var isOpen: Bool = false;

  override public function new(x: Float, y: Float) {
    super(x, y);
    loadGraphic('assets/images/door.png', false, 32, 64);
  }
}