package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class MenuState extends FlxState {
  var controlsText: String = 'Moverse:\nWASD/Flechas y ESPACIO\n\nAlterar tiempo:\nR';
  var titleText: String = 'Clockwarp';
  var inputActive: Bool = false;
  var title: FlxText;
  var controls: FlxText;

  override public function create(): Void {
    super.create();
    bgColor = FlxColor.fromString('#111111');
    var mid = {x: Std.int(FlxG.width / 2), y: Std.int(FlxG.height / 2)};
    controls = new FlxText(mid.x, mid.y + 100, 0, controlsText, 16);
    controls.alignment = CENTER;
    controls.x -= Std.int(controls.width / 2);
    add(controls);
    title = new FlxText(mid.x, mid.y - 200, 0, titleText, 64);
    title.alignment = CENTER;
    title.x -= Std.int(title.width / 2);
    add(title);
    haxe.Timer.delay(function() inputActive = true, 500);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    if (inputActive && FlxG.keys.anyJustPressed([W, A, S, D, UP, DOWN, LEFT, RIGHT, SPACE, R]))
      FlxG.switchState(new Level1());
  }
}