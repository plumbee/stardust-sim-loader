package coinBurst
{
import com.plumbee.stardustplayer.SimPlayer;
import com.plumbee.stardustplayer.StarlingSimBuilder;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.display.Bitmap;
import flash.events.Event;
import flash.utils.ByteArray;

import starling.display.DisplayObjectContainer;
import starling.display.Sprite;
import starling.events.EnterFrameEvent;
import starling.textures.Texture;
import starling.textures.TextureAtlas;

public class StarlingStardustExample extends Sprite
{
	[Embed(source="coins_particles.sde", mimeType='application/octet-stream')]
	private static var Asset : Class;
	private static var assetInstance : ByteArray = new Asset();

	public static var canvas : DisplayObjectContainer;
	private var player : SimPlayer;

	[Embed(source="emitterImage_0.png")]
	public static const Texture0 : Class;

	[Embed(source="emitterImage_1.png")]
	public static const Texture1 : Class;

	[Embed(source="emitterImage_2.png")]
	public static const Texture2 : Class;

	[Embed(source="emitterImage_0.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture0 : Class;

	[Embed(source="emitterImage_1.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture1 : Class;

	[Embed(source="emitterImage_2.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture2 : Class;

	public function StarlingStardustExample()
	{
		x = 190;
		y = 120;

		canvas = this;

		player = new SimPlayer();


		var project : ProjectValueObject = createProject();

		player.setSimulation(project, this);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function createAtlas(atlasTexture : Class, atlasXML : Class) : TextureAtlas
	{
		var bitmap : Bitmap = new atlasTexture();
		return new TextureAtlas(Texture.fromBitmap(bitmap), new XML(new atlasXML()));
	}

	private function createProject() : ProjectValueObject
	{
		var simBuilder : StarlingSimBuilder = new StarlingSimBuilder();

		return simBuilder.withSDE(assetInstance)
				.withTextures("coin", createAtlas(Texture0, AtlasTexture0))
				.withTextures("coin", createAtlas(Texture1, AtlasTexture1))
				.withTextures("coin", createAtlas(Texture2, AtlasTexture2))
				.build();

	}

	private function onEnterFrame(event : EnterFrameEvent) : void
	{
		player.stepSimulation();
	}
}
}
