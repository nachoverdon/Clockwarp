package utils;

import flixel.math.FlxPoint;

interface ActionFrames {
  public var position: FlxPoint;
  public var animationName: String;
  public var animationFrame: Int;
  public var flipX: Bool;
}