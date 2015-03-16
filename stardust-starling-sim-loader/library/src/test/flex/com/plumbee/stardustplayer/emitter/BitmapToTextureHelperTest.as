package com.plumbee.stardustplayer.emitter
{
import com.plumbee.stardustplayer.FlexUnitStarlingIntegration;
import com.plumbee.stardustplayer.FlexUnitStarlingIntegrationEvent;

import flash.display.BitmapData;

import idv.cjcat.stardustextended.twoD.initializers.BitmapParticleInit;

import org.flexunit.asserts.assertEquals;
import org.flexunit.async.Async;
import org.flexunit.rules.IMethodRule;
import org.mockito.integrations.flexunit4.MockitoRule;
import org.mockito.integrations.given;

import starling.textures.Texture;

public class BitmapToTextureHelperTest
{
	private var helper : BitmapToTextureHelper;
	private var initializer : BitmapParticleInit;

	[Rule]
	public var rule: IMethodRule = new MockitoRule();

	[Mock]
	public var texture: Texture;

	[Before(async, timeout=1000)]
	public function setUp() : void
	{
		Async.proceedOnEvent(this, FlexUnitStarlingIntegration.nativeStage, FlexUnitStarlingIntegrationEvent.CONTEXT_CREATED, 15500);
		FlexUnitStarlingIntegration.createStarlingContext();
		helper = new BitmapToTextureHelper();
		initializer = new BitmapParticleInit();
	}

	[Test]
	public function typeSingleImage_texturesSize1() : void
	{
		initializer.bitmapData = new BitmapData(1, 1);
		initializer.bitmapType = BitmapParticleInit.SINGLE_IMAGE;
		assertEquals(1, helper.getTexturesFromBitmapParticleInit(initializer).length);
	}

	[Test(expects="Error")]
	public function typeSingleImage_nullBitmap_throwsError() : void
	{
		initializer.bitmapData = null;
		initializer.bitmapType = BitmapParticleInit.SINGLE_IMAGE;
		helper.getTexturesFromBitmapParticleInit(initializer);
	}

	[Test]
	public function typeSpriteSheet_singleFrame_texturesSize1() : void
	{
		var width : uint = 1;
		initializer.bitmapData = new BitmapData(width, 1);
		initializer.spriteSheetSliceWidth = width;
		initializer.bitmapType = BitmapParticleInit.SINGLE_IMAGE;
		assertEquals(1, helper.getTexturesFromBitmapParticleInit(initializer).length);
	}

	[Test]
	public function typeSpriteSheet_multipleFrames_singleLine_texturesSizeNFrames() : void
	{
		const frameWidth : uint = 60;
		const frameHeight: uint = 50
		const frames : uint = 2;
		const spritesheetWidth : uint = frameWidth * frames;
		const spritesheetHeight: uint = frameHeight;
		setupTexture(spritesheetHeight, spritesheetWidth);
		initializer.spriteSheetSliceWidth = frameWidth;
		initializer.spriteSheetSliceHeight = spritesheetHeight;
		initializer.bitmapType = BitmapParticleInit.SPRITE_SHEET;
		assertEquals(frames, helper.getTexturesFromBitmapParticleInit(initializer, texture).length);
	}

	[Test]
	public function typeSpriteSheet_multipleLines_textureSizeIsRowsMultiplyCols() : void
	{
		const nRows : uint = 5;
		const nCols : uint = 5;
		const sliceSideLength: uint = 10
		setupTexture(nRows*sliceSideLength,nCols*sliceSideLength);
		initializer.spriteSheetSliceHeight = initializer.spriteSheetSliceWidth = sliceSideLength;
		initializer.bitmapData = new BitmapData(nCols, nRows);
		initializer.bitmapType = BitmapParticleInit.SPRITE_SHEET;
		assertEquals(nRows * nCols, helper.getTexturesFromBitmapParticleInit(initializer, texture).length);
	}

	[Test(expects="Error")]
	public function invalidType_throwsError() : void
	{
		initializer.bitmapData = new BitmapData(1,1);
		initializer.bitmapType = "invalid";
		helper.getTexturesFromBitmapParticleInit(initializer);
	}

	[After]
	public function tearDown() : void
	{
		FlexUnitStarlingIntegration.destroyStarlingContext();
	}

	private function setupTexture(height: int, width: int): void
	{
		given(texture.height).willReturn(height);
		given(texture.width).willReturn(width);
	}
}
}
