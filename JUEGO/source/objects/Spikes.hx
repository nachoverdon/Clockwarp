package objects;

import flixel.FlxSprite;

class Spikes extends FlxSprite {
  override public function new(x: Float, y: Float) {
    super(x, y);
    loadGraphic('assets/images/spikes.png', true, 32, 32);
    offset.set(0, -8);
    height = 24;
    // y += 8;
  }

  // override public function update(elapsed: Float) {
  //   super.update(elapsed);
  // }
}