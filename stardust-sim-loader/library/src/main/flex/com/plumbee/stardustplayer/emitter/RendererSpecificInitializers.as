package com.plumbee.stardustplayer.emitter
{
import idv.cjcat.stardustextended.twoD.initializers.PooledDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.PooledStarlingDisplayObjectClass;
import idv.cjcat.stardustextended.twoD.starling.StarlingDisplayObjectClass;

public class RendererSpecificInitializers
{
	public static function getList() : Vector.<Class>
	{
		return Vector.<Class>([
			StarlingDisplayObjectClass,
			PooledDisplayObjectClass,
			PooledStarlingDisplayObjectClass
		])
	}
}
}
