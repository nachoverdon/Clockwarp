package objects;

import flixel.FlxSprite;

class Spikes extends FlxSprite {
  override public function new(x: Float, y: Float) {
    super(x, y);
    loadGraphic('assets/images/spikes.png', true, 32, 32);
    var adjustY = 16;
    offset.set(0, adjustY);
    height -= adjustY;
    // updateHitbox();
    // drawDebug();
    this.y += adjustY;
  }

  // override public function update(elapsed: Float) {
  //   super.update(elapsed);
  // }
}