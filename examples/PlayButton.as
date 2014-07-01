package
{
import flash.display.Sprite;
import flash.events.MouseEvent;

public class PlayButton extends Sprite
{
	private const gfx : Sprite = new Sprite();

	public function PlayButton()
	{
		gfx.alpha = 0.7;

		gfx.graphics.lineStyle(5, 0x007F7F);
		gfx.graphics.drawCircle(0, 0, 50);
		gfx.graphics.lineStyle(0,0,0);

		gfx.graphics.beginFill(0x007F7F);
		gfx.graphics.moveTo(-15, -25);
		gfx.graphics.lineTo(25, 0);
		gfx.graphics.lineTo(-15, 25);
		gfx.graphics.endFill();

		gfx.graphics.beginFill(0x007F7F, 0);
		gfx.graphics.drawRect(-50,-50,100,100);

		addChild(gfx);
		gfx.x = gfx.y = 50;

		addEventListener(MouseEvent.ROLL_OVER, onRollOver);
		addEventListener(MouseEvent.ROLL_OUT, onRollOut);
		addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		addEventListener(MouseEvent.MOUSE_UP, onRollOut);
	}

	private function onDown(event : MouseEvent) : void
	{
		gfx.scaleX = gfx.scaleY = 0.8;
	}

	private function onRollOut(event : MouseEvent) : void
	{
		gfx.alpha = 0.7;
		gfx.scaleX = gfx.scaleY = 1;
	}

	private function onRollOver(event : MouseEvent) : void
	{
		gfx.alpha = 1;
	}
}
}
