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
	public function StarlingEmitterValueObject(emitterId : uint, emitter : Emitter2D, enableATFMode: Boolean = false)
	{
		super(emitterId, emitter);
		_emitter.particleHandler = new StarlingHandler(null, _emitter.blendMode, 0, enableATFMode);
		prepareForStarlingDefault();
	}

	private function prepareForStarlingDefault(): void
	{
		var bitmapInit: BitmapParticleInit = getValidBitmapInit();
		if(bitmapInit && bitmapInit.bitmapData)
		{
			createStarlingInitializerFromBitmapInitializerOnly(bitmapInit);
		}
	}

	public function prepareForStarlingWithAtlas(textureAtlas : Texture) : void
	{
		verifyNotAlreadyExistingTexture();
		addStarlingInitializersGivenAtlas(textureAtlas);
	}

	public function prepareForStarlingWithTextureList(textureList : Vector.<Texture>) : void
	{
		verifyNotAlreadyExistingTexture();
		addStarlingInitializersGivenTextureList(textureList);
	}

	public function prepareForStarlingWithSingleTexture(texture : Texture) : void
	{
		verifyNotAlreadyExistingTexture();
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

	private function createStarlingInitializerFromBitmapInitializerOnly(init: BitmapParticleInit): void
	{
		switch(init.bitmapType)
		{
			case BitmapParticleInit.SINGLE_IMAGE:
				addStarlingInitializerGivenSingleTexture(Texture.fromBitmapData(init.bitmapData));
				break;

			case BitmapParticleInit.SPRITE_SHEET:
				addStarlingInitializersGivenAtlas(Texture.fromBitmapData(init.bitmapData));
		}
	}

	private function verifyNotAlreadyExistingTexture(): void
	{
		const inits: Vector.<Initializer> = emitter.getInitializersByClass(PooledStarlingDisplayObjectClass);
		if(inits.length > 0 )
		{
			throw new Error("cannot register multiple texture sets to single emitter");
		}
	}

	private function getValidBitmapInit(): BitmapParticleInit
	{
		var bitmapInits : Vector.<Initializer> = _emitter.getInitializersByClass(BitmapParticleInit);
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