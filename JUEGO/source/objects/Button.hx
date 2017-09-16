package objects;

import flixel.FlxSprite;

class Button extends FlxSprite {
  public var id: Int;
  public var isPressed: Bool = false;

  override public function new(x: Float, y: Float, id: Int) {
    super(x, y);
    this.id = id;
    loadGraphic('assets/images/button.png', true, 32, 32);
    animation.add('notPressed', [1], 1, false);
    animation.add('pressed', [0], 1, false);
    animation.play('notPressed');
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);

    if (isPressed) animation.play('pressed');
    else animation.play('notPressed');
  }
}