package tv.turbodrive.away3d.materials
{
	import away3d.materials.TextureMaterial;
	import away3d.textures.ATFTexture;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import tv.turbodrive.away3d.textures.ASyncBitmapTexture;
	
	/**
	 * ATMaterial - AtlasTextureMaterial 
	 * 
	 */
	
	public class ATMaterial extends TextureMaterial
	{
		public var coordinates:Object
		public var rawCoords:Object
		public var width:int = 1024
		public var height:int = 1024
		
		public function ATMaterial(texture:Texture2DBase=null, smooth:Boolean=true, repeat:Boolean=false, mipmap:Boolean=true)
		{
			super(texture, smooth, repeat, mipmap);
			
			animateUVs = true;
			alphaBlending = true;
			repeat = true
			
			if(texture is BitmapTexture || texture is ASyncBitmapTexture){
				width = BitmapTexture(texture).bitmapData.width
				height = BitmapTexture(texture).bitmapData.height
			}
			if(texture is ATFTexture){
				width = ATFTexture(texture).atfData.width
				height = ATFTexture(texture).atfData.height
			}			
		}
		
	}
}