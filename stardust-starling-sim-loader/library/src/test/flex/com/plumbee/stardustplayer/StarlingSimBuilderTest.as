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
	private static const SDE_NUMBER_OF_TEXTURES : int = 3;

	[Embed(source="../../../../../test/resources/emitter.xml", mimeType="application/octet-stream")]
	private static var XmlSource : Class;
	private var xmlInstance : ByteArray;

	[Embed(source="../../../../../test/resources/emitter.png")]
	public static const Texture0 : Class;

	//The test sde contains 3 textures.
	[Embed(source="../../../../../test/resources/coins_particles.sde", mimeType='application/octet-stream')]
	private static var Asset : Class;
	private var sdeInstance : ByteArray;


	[Before(async, timeout=15500)]
	public function setUp() : void
	{

		xmlInstance = new XmlSource();
		sdeInstance = new Asset();
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
	public function canBuildWithEmitterAndTextureAtlas() : void
	{
		var projectValueObject : ProjectValueObject = new StarlingSimBuilder()
				.withEmitter(0, xmlInstance)
				.withTextureAtlas(Texture.fromBitmap(new Texture0()))
				.build();

		assertEquals(projectValueObject.numberOfEmitters, 1);

		var starlingEmitterVO : StarlingEmitterValueObject = projectValueObject.emitters[0] as StarlingEmitterValueObject;

		assertThatContainsStarlingDisplayObjectClassInitializer(starlingEmitterVO);
	}

	[Test]
	public function canBuildWithEmitterAndSingleTexture(): void
	{
		var projectValueObject: ProjectValueObject = new StarlingSimBuilder()
		.withEmitter(0, xmlInstance)
		.withSingleTexture(Texture.fromBitmap(new Texture0()))
		.build();

		assertEquals(projectValueObject.numberOfEmitters, 1);

		var starlingEmitterVO : StarlingEmitterValueObject = projectValueObject.emitters[0] as StarlingEmitterValueObject;

		assertThatContainsStarlingDisplayObjectClassInitializer(starlingEmitterVO);
	}

	[Test]
	public function canBuildWithSDEandVariousTextureTypeInitializers() : void
	{
		const texture: Texture = Texture.fromBitmap(new Texture0());

		var projectValueObject : ProjectValueObject = new StarlingSimBuilder()
				.withSDE(sdeInstance)
				.withTextureAtlas(texture)
				.withTextureList(Vector.<Texture>([texture, texture]))
				.withSingleTexture(texture)
				.build();

		assertEquals(projectValueObject.numberOfEmitters, SDE_NUMBER_OF_TEXTURES);

		assertThatContainsStarlingDisplayObjectClassInitializer(projectValueObject.emitters[0] as StarlingEmitterValueObject);
		assertThatContainsStarlingDisplayObjectClassInitializer(projectValueObject.emitters[1] as StarlingEmitterValueObject);
		assertThatContainsStarlingDisplayObjectClassInitializer(projectValueObject.emitters[2] as StarlingEmitterValueObject);
	}

	[Test(expects="Error")]
	public function attemptingToAddTexturesForMoreEmittersThanAreLoaded_throwsError(): void
	{
		const texture: Texture = Texture.fromBitmap(new Texture0());

		var projectValueObject : ProjectValueObject = new StarlingSimBuilder()
				.withSDE(sdeInstance)
				.withTextureAtlas(texture)
				.withTextureList(Vector.<Texture>([texture, texture]))
				.withSingleTexture(texture)
				.withSingleTexture(texture)
				.build();
	}

	[Test(expects="Error")]
	public function cantBuildWithOnlySDE() : void
	{
		new StarlingSimBuilder().withSDE(sdeInstance).build();
	}

	[Test(expects="Error")]
	public function cantBuildWithEmittersAndTextures() : void
	{
		new StarlingSimBuilder().build();
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

