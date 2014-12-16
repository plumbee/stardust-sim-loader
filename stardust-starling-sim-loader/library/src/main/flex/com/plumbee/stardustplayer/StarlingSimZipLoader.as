package com.plumbee.stardustplayer
{
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import org.as3commons.zip.Zip;

public class StarlingSimZipLoader
{

	public function extractEmittersFromZip(data : ByteArray) : Vector.<ByteArray>
	{
		var emitters : Vector.<ByteArray> = new Vector.<ByteArray>();
		const loadedZip : Zip = new Zip();
		loadedZip.loadBytes(data);
		for (var i : int = 0; i < loadedZip.getFileCount(); i++)
		{
			var loadedFileName : String = loadedZip.getFileAt(i).filename;
			if (ZipFileNames.isEmitterXMLName(loadedFileName))
			{
				emitters.push(loadedZip.getFileByName(loadedFileName).content);
			}
		}

		return emitters;
	}

}
}
