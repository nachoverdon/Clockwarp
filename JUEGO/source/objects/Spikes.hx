package objects;

import flixel.FlxSprite;

class Spikes extends FlxSprite {
  override public function new(x: Float, y: Float) {
    super(x, y);
    loadGraphic('assets/images/spikes.png', true, 32, 32);
  }

  // override public function update(elapsed: Float) {
  //   super.update(elapsed);
  // }
}