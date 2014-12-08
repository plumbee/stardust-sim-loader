package com.plumbee.stardustplayer
{
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import org.as3commons.zip.Zip;

public class StarlingSimZipLoader
{

	public function extractEmittersFromZip(data : ByteArray) : Dictionary
	{
		var emitters : Dictionary = new Dictionary();
		const loadedZip : Zip = new Zip();
		loadedZip.loadBytes(data);
		for (var i : int = 0; i < loadedZip.getFileCount(); i++)
		{
			var loadedFileName : String = loadedZip.getFileAt(i).filename;
			if (ZipFileNames.isEmitterXMLName(loadedFileName))
			{
				var emitterId : uint = ZipFileNames.getEmitterID(loadedFileName);
				emitters[emitterId] = loadedZip.getFileByName(loadedFileName).content;
			}
		}

		return emitters;
	}

}
}
