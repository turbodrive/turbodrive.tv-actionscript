package tv.turbodrive.away3d.materials
{
	import flash.geom.ColorTransform;
	
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.textures.BitmapTexture;

	public class MaterialHelper
	{
		public function MaterialHelper()
		{
		}
		
		public static function cloneTextureMaterial(source:TextureMaterial, newName:String = ""):TextureMaterial
		{
			var clone:TextureMaterial = new TextureMaterial(source.texture,source.smooth, source.repeat, source.mipmap);
			clone.alphaBlending = source.alphaBlending
			clone.alpha = source.alpha
			clone.alphaPremultiplied = source.alphaPremultiplied
			clone.blendMode = source.blendMode
			clone.colorTransform = source.colorTransform
			clone.animateUVs = source.animateUVs
			clone.bothSides = source.bothSides
			clone.repeat = source.repeat
			clone.lightPicker = source.lightPicker
			if(source.ambientTexture){
				clone.ambientTexture = source.ambientTexture
				if(clone.alphaBlending){
					clone.colorTransform = new ColorTransform(2,2,2,2,0,0,0,0)
				}
			}
			clone.ambient = source.ambient
			clone.ambientColor = source.ambientColor
			clone.name = source.name + "-Clone" + newName
				
			return clone
		}
		
		public static function cloneATMaterial(source:ATMaterial, newName:String = ""):ATMaterial
		{
			var clone:ATMaterial = new ATMaterial(source.texture,source.smooth, source.repeat, source.mipmap);
			clone.alphaBlending = source.alphaBlending
			clone.alpha = source.alpha
			clone.alphaPremultiplied = source.alphaPremultiplied
			clone.blendMode = source.blendMode
			clone.colorTransform = source.colorTransform
			clone.animateUVs = source.animateUVs
			clone.bothSides = source.bothSides
			clone.coordinates = source.coordinates
			clone.repeat = source.repeat
			clone.lightPicker = source.lightPicker
			if(source.ambientTexture){
				clone.ambientTexture = source.ambientTexture
				if(clone.alphaBlending){
					clone.colorTransform = new ColorTransform(2,2,2,2,0,0,0,0)
				}
			}
			clone.ambient = source.ambient
			clone.ambientColor = source.ambientColor
			clone.name = source.name + "-Clone" + newName
			
			return clone
		}
		
		public static function cloneColorMaterial(source:ColorMaterial):ColorMaterial
		{
			var clone:ColorMaterial = new ColorMaterial(source.color, source.alpha);
			clone.alphaBlending = source.alphaBlending
			clone.alpha = source.alpha
			clone.alphaPremultiplied = source.alphaPremultiplied
			clone.blendMode = source.blendMode
			clone.colorTransform = source.colorTransform
			clone.bothSides = source.bothSides
			clone.lightPicker = source.lightPicker
						
			return clone
		}
	}
}