package tv.turbodrive.away3d.elements.entities
{
	import flash.geom.Rectangle;
	
	import away3d.core.base.SubMesh;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.events.ViewRender3DEvent;
	
	public class PlaneMesh extends PerspScaleMesh
	{
		public static const WHOLE_TEXTURE:String = "## wholeTexture"
		//public static const DEFAULT_AREA:String = "## defaultArea"
		public static const MAIN_AREA:String = "mainArea"
		
		private var _initTextureWidth:int = 1024	
		private var _initTextureHeight:int = 1024	
		private var _width:Number
		private var _height:Number
		private var _modHeight:Number
		private var _scUVHeight:Number = 1;
		protected var _atlasArea:Rectangle
		
		private var _initWidth:Number = 0
		private var _initHeight:Number = 0
	
		private var _scaleTexX:int = 1;	
		private var _scaleTexY:int = 1;	
		private var _scUVHeightOffset:Number = 0;
		
		private var _scaleDirty:Boolean = false		
		private var _positionDirty:Boolean = false		

		private var _traceRender:Boolean = false;
		private var _rawBounds:Boolean = false
		
		/**
		 * options : {rawBounds:true, width:Number = -1, height:Number = -1, scaleTexX:int = 1, scaleTexY:int = 1}
		 */
		public function PlaneMesh(material:MaterialBase, idArea:String = null, options:Object = null)
		{
			if(options){
				if(options.rawBounds) _rawBounds = options.rawBounds
				if(options.scaleTexX) _scaleTexX = options.scaleTexX
				if(options.scaleTexX) _scaleTexY = options.scaleTexY
				if(options.pixelPerfectScale != null){
					trace("set pixelPerfectScale >> " + options.pixelPerfectScale)
					pixelPerfectScale = options.pixelPerfectScale
				}
			}
			
			if(material is ATMaterial){
				_initTextureWidth = ATMaterial(material).width
				_initTextureHeight = ATMaterial(material).height				
				if(idArea){
					if(idArea == WHOLE_TEXTURE){
						// the whole texture area
						_atlasArea = new Rectangle(0,0,_initTextureWidth,_initTextureHeight);
					}else{
						if(_rawBounds){
							_atlasArea =  ATMaterial(material).rawCoords[idArea]
						}else{
							_atlasArea = ATMaterial(material).coordinates[idArea]
						}
					}					
					_width = _initWidth = _atlasArea.width/_scaleTexX
					_height = _initHeight = _atlasArea.height/_scaleTexY
				}
			}
			
			if(options){
				if(options.width) _width = _initWidth = options.width
				if(options.height) _height = _initHeight = options.height
			}
			
			super(new PlaneGeometry(width,height,1,1,false,false), material);
			
			if(_atlasArea){
				adjustUVs(_atlasArea);
			}else if(_scaleTexX != 1 || _scaleTexY != 1){
				var subMesh:SubMesh = subMeshes[0] as SubMesh
				subMesh.scaleU = _scaleTexX
				subMesh.scaleV = _scaleTexY
				if(material is ATMaterial) ATMaterial(material).animateUVs = false
			}
			
			_positionDirty = true
			if(material is TextureMaterial){
				TextureMaterial(material).texture.getTextureForStage3D(_viewRenderer.s3dProxy);
			}
			_viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender)
			onRender(null)
		}
				
		override public function adjustUVs(atlasArea:Rectangle = null, textureWidth:int = -1, textureHeight:int = -1, scaleTexX:int = -1, scaleTexY:int = -1):void
		{
			textureWidth = textureWidth > -1 ? textureWidth : _initTextureWidth
			textureHeight = textureHeight > -1 ? textureHeight : _initTextureHeight
			scaleTexX = scaleTexX > -1 ? scaleTexX : _scaleTexX
			scaleTexY = scaleTexY > -1 ? scaleTexY : _scaleTexY
			super.adjustUVs(atlasArea, textureWidth, textureHeight, scaleTexX, scaleTexY)	
		}
		
		public function traceInfos():void
		{
			_traceRender = true
			trace("_atlasArea = " + _atlasArea)
			trace("subMesh.offsetV = " + SubMesh(subMeshes[0]).offsetV)
			trace("subMesh.scaleV = " + SubMesh(subMeshes[0]).scaleV)
			trace("super.y " + super.y)
			trace("super.x " + super.x)
			trace("_scale " + _scale)
			trace("z " + z)
		}
	
		
		public function set height(value:Number):void
		{
			_height = value
			_scZ = _height/_initHeight
			_uvDirty = true
			_scaleDirty = true
		}
		
		public function set width(value:Number):void
		{
			_width = value
			_scX = _width/_initWidth
			_uvDirty = true
			_scaleDirty = true
		}	
		
		public function get width():Number
		{
			return _width
		}		
		
		public function get height():Number
		{
			return _height
		}
		
		public function get alpha():Number
		{
			if(material is TextureMaterial) return TextureMaterial(material).alpha
			return ColorMaterial(material).alpha
		}
		
		public function set alpha(value:Number):void
		{
			if(material is TextureMaterial){
				TextureMaterial(material).alpha = value
			}else{
				ColorMaterial(material).alpha = value
			}
		}
		
		override public function dispose():void
		{
			_atlasArea = null
			_viewRenderer.removeEventListener(ViewRender3DEvent.ON_RENDER, onRender)
			super.dispose();
		}	
		
		public static function getCrossHelper():PlaneMesh
		{
			return new PlaneMesh(MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI),"helperCross");
		}
		
	}
}