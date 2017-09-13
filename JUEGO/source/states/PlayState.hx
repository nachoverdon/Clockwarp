package states;

import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	override public function create():Void
	{
		super.create();
		bgColor = FlxColor.fromString('#111111');
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
