package examples.coinBurst
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;

import starling.core.Starling;

[SWF(width="400", height="250", backgroundColor="#454545", frameRate="60")]
public class CoinBurstExample extends Sprite
{
	private var starling : Starling;

	public function CoinBurstExample()
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		starling = new Starling(StarlingStardustExample, stage);
		starling.start();
	}
}
}
