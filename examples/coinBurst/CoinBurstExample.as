package coinBurst {

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.utils.ByteArray;

[SWF(width="400", height="250", backgroundColor="#454545", frameRate="40")]
public class CoinBurstExample extends Sprite
{
	[Embed(source="coins_particles.sde", mimeType = 'application/octet-stream')]
	private static var Asset:Class;
	private static var assetInstance:ByteArray = new Asset();

	private var playButton : PlayButton;

	public function CoinBurstExample()
	{
		playButton = new PlayButton();
		addChild(playButton);
		playButton.addEventListener(MouseEvent.CLICK, onClick);
		playButton.x = stage.stageWidth / 2 - 50;
		playButton.y = stage.stageHeight / 2 - 50;
	}

	private function onClick(event : MouseEvent) : void
	{
		playButton.removeEventListener(MouseEvent.CLICK, onClick);
		removeChild(playButton);
		var player : ExampleSimPlayer = new ExampleSimPlayer();
		player.x = 190;
		player.y = 120;
		addChild(player);
		player.loadSim(assetInstance);
	}
}
}
