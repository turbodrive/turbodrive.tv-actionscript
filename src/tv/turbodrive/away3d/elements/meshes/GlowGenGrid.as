package tv.turbodrive.away3d.elements.meshes
{
	import flash.display.BlendMode;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	
	import tv.turbodrive.away3d.materials.MaterialHelper;
	
	public class GlowGenGrid extends ObjectContainer3D
	{
		public static const NORMAL:String = "normalGrid"
		public static const GRADIENT:String = "gradientGrid"
		public static const TRIANGLE:String = "triangleGrid"		
		
		private var _width:int = 0
		private var _height:int = 0
		private var _type:String
		//private var _gradient:Boolean = false
		
		private var _mainGrid:Mesh
		private var _gradientGrid:Mesh
		private var _gradientGrid2:Mesh		
		
		private var ratioUV_Size:Number = 1/32
		private var _heightGradient:int = 512
		private static const ALPHA_MAX:Number = 0.3
		private var _alpha:Number = 1
			
		private var _material:TextureMaterial
		private var _gradientMaterial:TextureMaterial
		
		private var _heightPlain:int;
		public function GlowGenGrid(width:int, height:int, type:String = "normalGrid")
		{
			_width = width;
			_height = height;
			//gradient = gradient;
			_type = type
			if(_type == TRIANGLE) ratioUV_Size = 1/128
			build()	
		}
		
		private function build():void
		{
			if(_type == GRADIENT && _height < _heightGradient*2){
				throw new Error("height less than 1024px and gradient at same time are impossible")
			}
			
			_heightPlain = 0
			
			if(_type == GRADIENT){
				_heightPlain = _height - (_heightGradient*2)
				var textureGradient:BitmapTexture = BitmapTexture(TextureMaterial(AssetLibrary.getAsset("GradientMaterial")).texture);
				_gradientMaterial = new TextureMaterial(new BitmapTexture(textureGradient.bitmapData), true, true, true);
				_gradientMaterial.alpha = ALPHA_MAX
				_gradientMaterial.alphaBlending = true
				_gradientMaterial.alphaPremultiplied = false
				_gradientMaterial.blendMode = BlendMode.ADD
				_gradientMaterial.bothSides = true	
				
				_gradientGrid = new Mesh(new PlaneGeometry(), _gradientMaterial)			
				addChild(_gradientGrid)
				
				_gradientGrid2 = new Mesh(new PlaneGeometry(), _gradientMaterial)	
				addChild(_gradientGrid2)
				
			}else{
				_heightPlain = _height
			}
			if(_type == TRIANGLE){
				_material = MaterialHelper.cloneTextureMaterial(AssetLibrary.getAsset("TrigridMaterial") as TextureMaterial)
			}else{
				var texture:BitmapTexture = BitmapTexture(TextureMaterial(AssetLibrary.getAsset("GridMaterial")).texture);
				_material = new TextureMaterial(new BitmapTexture(texture.bitmapData), true, true, true);
				_material.alphaPremultiplied = false;
				_material.blendMode = BlendMode.ADD
			}
			_material.alpha = ALPHA_MAX
			_material.alphaBlending = true
			_material.bothSides = true
				
			_mainGrid = new Mesh(new PlaneGeometry(),_material)
			if(_heightPlain >= 32) addChild(_mainGrid)
			
			updateSizeAndUVs()
		}
		
		private function updateSizeAndUVs():void			
		{
			var _offsetZ:int = 0
			
			if(_gradientGrid){
				TextureMaterial(_gradientGrid.material).animateUVs = true
				var geomGradient:PlaneGeometry = PlaneGeometry(_gradientGrid.geometry)
				geomGradient.width = _width
				geomGradient.height = _heightGradient-1
				var scaleV:Number = 1-((1/512)*1)
				geomGradient.scaleUV(_width*ratioUV_Size, scaleV)
				_offsetZ = ((_heightGradient+_heightPlain)/2)-1
				_gradientGrid.position = new Vector3D(0,0,_offsetZ);
				
				geomGradient = PlaneGeometry(_gradientGrid2.geometry)
				geomGradient.width = _width
				geomGradient.height = _heightGradient
				geomGradient.scaleUV(_width*ratioUV_Size, scaleV)
				_gradientGrid2.subMeshes[0].offsetV = _gradientGrid.subMeshes[0].offsetV = (1/512)*1
				_gradientGrid2.position = new Vector3D(-1,0,-_offsetZ);
				_gradientGrid2.rotationY = 180
				
			}
			var geomPlain:PlaneGeometry = PlaneGeometry(_mainGrid.geometry)
			geomPlain.width = _width
			geomPlain.height = _heightPlain
			geomPlain.scaleUV(_width*ratioUV_Size, _heightPlain*ratioUV_Size)
			//_mainGrid.position = new Vector3D(0,0, _offsetZ - (_height >> 1));
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value
			_material.alpha = _alpha*ALPHA_MAX
			if(_gradientGrid) TextureMaterial(_gradientGrid.material).alpha = _material.alpha
		}
		
		public function get alpha():Number
		{
			return _alpha
		}
		
		public function get width():int
		{
			return _width
		}
		
		public function get height():int
		{
			return _height
		}
	}
}