package com.plumbee.stardustplayer.emitter
{

import idv.cjcat.stardustextended.common.initializers.Initializer;
import idv.cjcat.stardustextended.sd;
import idv.cjcat.stardustextended.twoD.emitters.Emitter2D;
import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;
import idv.cjcat.stardustextended.twoD.starling.ParticleConfig;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingHandler;

import starling.display.DisplayObjectContainer;
import starling.textures.Texture;

use namespace sd;

public class StarlingEmitterValueObject extends BaseEmitterValueObject implements IStarlingEmitter
{
	public function StarlingEmitterValueObject(emitterId : uint, emitter : Emitter2D)
	{
		super(emitterId, emitter);
		emitter.particleHandler = new StarlingHandler();
	}

	public function prepareForStarlingWithAtlas(textureAtlas : Texture) : void
	{
		addStarlingInitializersGivenAtlas(textureAtlas);
	}

	public function prepareForStarlingWithTextureList(textureList : Vector.<Texture>) : void
	{
		addStarlingInitializersGivenTextureList(textureList);
	}

	public function prepareForStarlingWithSingleTexture(texture : Texture) : void
	{
		addStarlingInitializerGivenSingleTexture(texture);
	}

	private function addStarlingInitializersGivenAtlas(textureAtlas: Texture) : void
	{
		const bitmapInit: BitmapParticleInit = getValidBitmapInit();
		if(bitmapInit)
		{
			emitter.addInitializer
			(
					createStarlingInitializerFromBitmapInitializerWithTextureAtlas(bitmapInit,textureAtlas)
			);
		}
	}

	private function addStarlingInitializersGivenTextureList(textureList: Vector.<Texture>): void
	{
		const bitmapInit: BitmapParticleInit = getValidBitmapInit();
		if(bitmapInit)
		{
			emitter.addInitializer
			(
					createStarlingInitializerFromBitmapInitializerWithTextureList(bitmapInit,textureList)
			);
		}
	}

	private function addStarlingInitializerGivenSingleTexture(texture: Texture): void
	{
		const bitmapInit: BitmapParticleInit = getValidBitmapInit();
		if(bitmapInit)
		{
			emitter.addInitializer
			(
					createStarlingInitializerWithSingleTexture(texture)
			);
		}
	}

	public function updateHandlerCanvas(canvas : DisplayObjectContainer) : void
	{
		(emitter.particleHandler as StarlingHandler).container = canvas;
	}

	private function createStarlingInitializerWithSingleTexture(texture : Texture) : Initializer
	{
		return new PooledStarlingDisplayObjectClass(StarlingBitmapParticle, [Vector.<Texture>([texture])] );
	}

	private function createStarlingInitializerFromBitmapInitializerWithTextureAtlas(initializer : BitmapParticleInit, textureAtlas: Texture) : Initializer
	{
		var config : ParticleConfig = new ParticleConfig(initializer.spriteSheetAnimationSpeed, initializer.spriteSheetStartAtRandomFrame);

		return new PooledStarlingDisplayObjectClass(StarlingBitmapParticle, [getBitmapToTextureHelper().getTexturesFromSpriteSheetAndBitmapParticleInit(initializer, textureAtlas)], config);
	}

	private function createStarlingInitializerFromBitmapInitializerWithTextureList(initializer : BitmapParticleInit, textureList: Vector.<Texture>) : Initializer
	{
		var config : ParticleConfig = new ParticleConfig(initializer.spriteSheetAnimationSpeed, initializer.spriteSheetStartAtRandomFrame);

		return new PooledStarlingDisplayObjectClass(StarlingBitmapParticle, [textureList], config);
	}

	private function getValidBitmapInit(): BitmapParticleInit
	{
		var bitmapInits : Vector.<Initializer> = emitter.getInitializersByClass(BitmapParticleInit);
		if(bitmapInits.length < 2 && bitmapInits.length > 0)
		{
			return bitmapInits[0] as BitmapParticleInit;
		}
		else if(bitmapInits.length >= 2)
		{
			throw(new Error("can't have multiple BitmapParticleInit"));
		}
		else return null;
	}

	protected function getBitmapToTextureHelper() : BitmapToTextureHelper
	{
		return new BitmapToTextureHelper();
	}
}
}