package coinBurst
{
import com.plumbee.stardustplayer.SimPlayer;
import com.plumbee.stardustplayer.StarlingSimBuilder;
import com.plumbee.stardustplayer.StarlingSimZipLoader;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.display.Bitmap;
import flash.events.Event;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

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

		var emitters : Dictionary = new StarlingSimZipLoader().extractEmittersFromZip(assetInstance);

		var project : ProjectValueObject = createProject(emitters);

		player.setSimulation(project, this);

		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function createAtlas(atlasTexture : Class, atlasXML : Class)
	{
		var bitmap : Bitmap = new atlasTexture();
		return new TextureAtlas(Texture.fromBitmap(bitmap), new XML(new atlasXML()));
	}

	private function createProject(emitters : Dictionary) : ProjectValueObject
	{
		var emitters : Dictionary = new StarlingSimZipLoader().extractEmittersFromZip(assetInstance);

		var simBuilder : StarlingSimBuilder = new StarlingSimBuilder();
		var i : int = 0;
		for each (var emitter2D : ByteArray in emitters)
		{
			simBuilder.withEmitter(i, emitter2D);
			i++;
		}
		simBuilder.withTextures(0, "coin", createAtlas(Texture0, AtlasTexture0));
		simBuilder.withTextures(1, "coin", createAtlas(Texture1, AtlasTexture1));
		simBuilder.withTextures(2, "coin", createAtlas(Texture2, AtlasTexture2));

		return simBuilder.build();

	}

	private function onEnterFrame(event : EnterFrameEvent) : void
	{
		player.stepSimulation();
	}
}
}
