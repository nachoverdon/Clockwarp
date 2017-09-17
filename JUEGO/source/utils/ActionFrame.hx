package utils;

import flixel.math.FlxPoint;

typedef ActionFrame = {
  var position: FlxPoint;
  var animationName: String;
  var animationFrame: Int;
  var flipX: Bool;
}