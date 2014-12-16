package com.plumbee.stardustplayer
{
import com.plumbee.stardustplayer.emitter.StarlingEmitterValueObject;
import com.plumbee.stardustplayer.project.ProjectValueObject;

import flash.display.Bitmap;
import flash.utils.ByteArray;

import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;

import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertTrue;
import org.flexunit.async.Async;

import starling.textures.Texture;
import starling.textures.TextureAtlas;

use namespace sd;

public class StarlingSimBuilderTest
{
	[Embed(source="../../../../../test/resources/emitter.xml", mimeType="application/octet-stream")]
	private static var XmlSource : Class;
	private var xmlInstance : ByteArray;

	[Embed(source="../../../../../test/resources/emitter.png")]
	public static const Texture0 : Class;

	[Embed(source="../../../../../test/resources/textureAtlas.xml", mimeType="application/octet-stream")]
	public static const AtlasTexture0 : Class;


	[Before(async, timeout=15500)]
	public function setUp() : void
	{

		xmlInstance = new XmlSource();
		Async.proceedOnEvent(this, FlexUnitStarlingIntegration.nativeStage, FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED, 15500);
		FlexUnitStarlingIntegration.createStarlingContext();
	}


	[After]
	public function tearDown() : void
	{
		FlexUnitStarlingIntegration.destroyStarlingContext();
	}

	[Test(expects="Error")]
	public function cantBuildWithOnlyEmitters() : void
	{
		new StarlingSimBuilder().withEmitter(0, xmlInstance).build();
	}

	[Test]
	public function canBuildWithEmitterAndTexture() : void
	{
		var projectValueObject : ProjectValueObject = new StarlingSimBuilder()
				.withEmitter(0, xmlInstance)
				.withTextures("coin", createAtlas(Texture0, AtlasTexture0))
				.build();

		assertEquals(projectValueObject.numberOfEmitters, 1);

		var starlingEmitterVO : StarlingEmitterValueObject = projectValueObject.emitters[0] as StarlingEmitterValueObject;

		assertThatContainsStarlingDisplayObjectClassInitializer(starlingEmitterVO);
	}

	private function assertThatContainsStarlingDisplayObjectClassInitializer(starlingEmitterVO : StarlingEmitterValueObject) : void
	{
		var containsStarlingDisplayObjectClass : Boolean;
		for each (var initializer : Object in starlingEmitterVO.emitter.sd::initializers)
		{
			if (initializer is PooledStarlingDisplayObjectClass)
			{
				containsStarlingDisplayObjectClass = true;
			}
		}

		assertTrue(containsStarlingDisplayObjectClass);
	}


	private function createAtlas(atlasTexture : Class, atlasXML : Class) : TextureAtlas
	{
		var bitmap : Bitmap = new atlasTexture();
		return new TextureAtlas(Texture.fromBitmap(bitmap), new XML(new atlasXML()));
	}


}
}

