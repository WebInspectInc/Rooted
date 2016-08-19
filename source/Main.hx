package;

import flixel.FlxGame;
import states.PlayState;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(640, 480, PlayState));
	}
}