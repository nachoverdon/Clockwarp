package states;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import objects.Player;

class PlayState extends FlxState
{
	var player: Player;
	var floor: FlxSprite;
	override public function create():Void
	{
		super.create();
		bgColor = FlxColor.fromString('#111111');
		player = new Player(50, FlxG.height - 32);
		add(player);
		floor = new FlxSprite(0, FlxG.height - 10);
		floor.makeGraphic(FlxG.width, 10, FlxColor.RED);
		floor.immovable = true;
		add(floor);

	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(player, floor);
	}
}
