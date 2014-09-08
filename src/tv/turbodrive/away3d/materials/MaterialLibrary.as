package tv.turbodrive.away3d.materials
{
	import flash.geom.Rectangle;
	
	import away3d.materials.ColorMaterial;
	
	import tv.turbodrive.utils.Colors;

	/**
	 * ATMaterialList - AtlasTextureMaterialList
	 * 
	 */
	
	public class MaterialLibrary
	{				
		private static var _materialList:Array = []
		private static var tot:Array = []		
		private static var ikaf:Array = []		
		private static var ikaf2:Array = []		
		private static var tl:Array = []		
		private static var borgia:Array = []
		private static var gs:Array = []
		private static var greetings:Array = []		
		private static var ui:Array = []
			
		private static var jpegs1024:Array = []
		private static var jpg2048_001:Array = []			
			
		private static var trigrid:Array = []
			
		private static var _visuelRect:Rectangle = new Rectangle(0,448,1024,576)
		private static var _workRect:Rectangle = new Rectangle(0,60,330,76)		
		private static var _jpegList:Array = [];
		
		private static var gradient_001:Object = {}
		private static var violetBg:Object = {}
			
		public static var GLOBAL_RED:ColorMaterial
		public static var GLOBAL_TRANSPARENT_PURPLE:ColorMaterial
		
		public function MaterialLibrary()
		{
			GLOBAL_RED = new ColorMaterial(Colors.VINTAGE_RED)
			GLOBAL_RED.alphaPremultiplied = false
			GLOBAL_TRANSPARENT_PURPLE = new ColorMaterial(0x201026,0.65)
			GLOBAL_TRANSPARENT_PURPLE.alphaPremultiplied = false
			
			MaterialLibrary.jpegs1024["gs"] = [new Rectangle(0,0,1024,688)]
			MaterialLibrary.jpegs1024["tot"] = [new Rectangle(0,0,1024,669)]
			MaterialLibrary.jpegs1024["ikaf"] = [new Rectangle(0,0,1024,687)]
			MaterialLibrary.jpegs1024["ikaf2"] = [new Rectangle(0,0,1024,688)]
			MaterialLibrary.jpegs1024["borgia"] = [new Rectangle(0,0,1024,660)]
			MaterialLibrary.jpegs1024["greetings"] = [new Rectangle(0,0,1024,576)]
			MaterialLibrary.jpegs1024["tl"] = [new Rectangle(0,0,1024,576)]
				
			MaterialLibrary.gradient_001.blue = new Rectangle(0,0,585,100) // blue gradient
			MaterialLibrary.gradient_001.red = new Rectangle(0,100,585,100) // red gradient
			MaterialLibrary.violetBg.mainArea = new Rectangle(384,664,1280,720) // main VioletBg				
				
			MaterialLibrary.ui[0] = new Rectangle(0,0,108,22) // bouton credits (animé)
			MaterialLibrary.ui[1] = new Rectangle(0,50,109,36) // viewer titre
			MaterialLibrary.ui[2] = new Rectangle(110,50,23,36) // viewer 1
			MaterialLibrary.ui[3] = new Rectangle(133,50,22,36) // viewer 2
			MaterialLibrary.ui[4] = new Rectangle(155,50,23,36) // viewer 3
			MaterialLibrary.ui[5] = new Rectangle(178,50,22,36) // viewer 4
			MaterialLibrary.ui[6] = new Rectangle(200,50,23,36) // viewer 5
			MaterialLibrary.ui[7] = new Rectangle(223,50,33,36) // viewer 6
			MaterialLibrary.ui[8] = new Rectangle(320,50,320,72) // animation panel viewer			
		}
		
		public static function addAndpopulate(atlasName:String, material:ATMaterial):void
		{
			//if(atlasName == ATMaterialName.SKYBOX_CUBEMAP) return
			if(!material.coordinates){
				material.coordinates = material.rawCoords = MaterialLibrary[atlasName]
			}
		
			MaterialLibrary._materialList[atlasName] = material
			trace("ATF Texture Material '" + atlasName + "' initialized.")
		}
		
		public static function addJpegProjectBitmap(atlasName:String, material:ATMaterial):void
		{
			if(material.coordinates.length == 0) material.coordinates = MaterialLibrary.jpegs1024[atlasName] as Array
				
			if(!MaterialLibrary._jpegList[atlasName]){
				MaterialLibrary._jpegList[atlasName] = new Array();
			}
			MaterialLibrary._jpegList[atlasName].push(material)
			//ATMaterialList._jpegList[atlasName] = material
			//trace("ATF JPEG PROJECT Material '" + atlasName + "' added.")
		}
		
		public static function getJpegProjectMaterial(name:String, id:String):ATMaterial
		{
			return ATMaterial(MaterialLibrary._jpegList[name][id]);
		}
		
		
		public static function getMaterial(atlasName:String):ATMaterial
		{
			return ATMaterial(MaterialLibrary._materialList[atlasName])
		}
	}
}