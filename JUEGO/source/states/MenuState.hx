package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState {
  var play: String = 'WASD/Flechas, ESPACIO y R';
  var inputActive: Bool = false;
  var text: FlxText;

  override public function create(): Void {
    super.create();
    bgColor = FlxColor.fromString('#111111');
    text = new FlxText(
      FlxG.width / 2,
      FlxG.height / 2,
      0,
      play,
      32
    );
    text.x -= Std.int(text.width / 2);
    text.y -= Std.int(text.height / 2);
    add(text);
    haxe.Timer.delay(function() inputActive = true, 1000);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    if (inputActive && FlxG.keys.justPressed.ANY) FlxG.switchState(new Level1());
  }
}