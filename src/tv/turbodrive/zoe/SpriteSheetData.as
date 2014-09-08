package tv.turbodrive.zoe
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import away3d.textures.ATFTexture;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.textures.ASyncBitmapTexture;

	public class SpriteSheetData
	{
		private var _spriteSheetBitmapData:BitmapData
		private var _spriteSheetByte:ByteArray
		
		private var _spriteSheetData:Object;
		private var _isAtf:Boolean = false
			
		private var _boundSize:int = 4
		
		public function SpriteSheetData(spriteSheetImage:*, rawJsonData:String)
		{
			if(spriteSheetImage is Bitmap){
				_spriteSheetBitmapData = Bitmap(spriteSheetImage).bitmapData
			} else if(spriteSheetImage is BitmapData){
				_spriteSheetBitmapData = spriteSheetImage as BitmapData
			} else{
				_spriteSheetByte = spriteSheetImage as ByteArray
				_isAtf = true
			}
			parse(rawJsonData)
		}
		
		private function parse(data:String):void
		{
			_spriteSheetData = JSON.parse(data);
		}
		
		public function getAreaRect(animationName:String, frameIndex:int = 0, raw:Boolean = false):Rectangle
		{
			if(_spriteSheetData.animations[animationName]){
					var framesArray:Array = _spriteSheetData.animations[animationName].frames
					return getInternalFrameRect(framesArray[frameIndex], raw)
			}			
			return null
		}
		
		private function makePairNumber(value:Number):Number
		{
			if(value >> 1 == value*.5) return value
			return value+1
		}
		
		public function getInternalFrameRect(id:int, raw:Boolean = false):Rectangle
		{
			if(raw) return new Rectangle(makePairNumber(_spriteSheetData.frames[id][0]),makePairNumber(_spriteSheetData.frames[id][1]),makePairNumber(_spriteSheetData.frames[id][2]),makePairNumber(_spriteSheetData.frames[id][3]));
			return new Rectangle(makePairNumber(_spriteSheetData.frames[id][0]-_boundSize),makePairNumber(_spriteSheetData.frames[id][1]-_boundSize),makePairNumber(_spriteSheetData.frames[id][2]),makePairNumber(_spriteSheetData.frames[id][3]));
		}
		
		public function createATMaterial(type:String = null):ATMaterial
		{			
			var texture:Texture2DBase
			if(!type){
				if(_isAtf){
					type = TextureType.ATF
				}else{
					type = TextureType.BITMAP
				}
			}
				
			if(type == TextureType.ASYNCH_BITMAP){
				texture = new ASyncBitmapTexture(_spriteSheetBitmapData)
			}else if(type == TextureType.BITMAP){
				texture = new BitmapTexture(_spriteSheetBitmapData)
			}else if(type == TextureType.ATF){
				texture = new ATFTexture(_spriteSheetByte)
			}
				
			var material:ATMaterial = new ATMaterial(texture) as ATMaterial;
			material.repeat = true
			material.coordinates = {};
			material.rawCoords = {};
			for(var p:String in _spriteSheetData.animations)
			{
				var animName:String = p
				var animInfos:Object = _spriteSheetData.animations[p]
				var animFrames:Array = animInfos.frames
				var coordArea:Rectangle = getAreaRect(animName,0)
				var rawCoordArea:Rectangle = getAreaRect(animName,0, true)
				material.coordinates[animName] = coordArea
				material.rawCoords[animName] = rawCoordArea
				material.name = _spriteSheetData.images[0]
			}
			
			return material			
		}
		
		
		public static function createATMat2(image:*, type:String = null):ATMaterial
		{	
			if(image is ByteArray){
				type = TextureType.ATF
			}else {			
				var bData:BitmapData
				if(image is Bitmap){
					bData = image.bitmapData
				}else{
					bData = image as BitmapData
				}
			}
			
			var texture:Texture2DBase
			if(type == TextureType.ATF){
				texture = new ATFTexture(image as ByteArray)
			}else if(type == TextureType.ASYNCH_BITMAP){
				texture = new ASyncBitmapTexture(bData)				
			}else{				
				texture = new BitmapTexture(bData)
			}

			var material:ATMaterial = new ATMaterial(texture) as ATMaterial;
			
			return material			
		}
	}
}