package objects;

import flixel.FlxSprite;

class Pickup extends FlxSprite {
  var amount: Int = 4;

  override public function new(x: Float, y: Float) {
    super(x, y);
    loadGraphic('assets/images/pickup.png', true, 32, 32);
    // animation.add('spin', [for (i in 0...amount) i], 3, true);
    animation.add('spin', [0, 3, 1, 2], 3, true);
    animation.play('spin');
  }
}