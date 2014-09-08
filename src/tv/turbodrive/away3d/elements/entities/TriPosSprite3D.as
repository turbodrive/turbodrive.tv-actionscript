package tv.turbodrive.away3d.elements.entities
{	
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.entities.Sprite3D;
	import away3d.events.Object3DEvent;
	import away3d.materials.ColorMaterial;
	import away3d.tools.utils.Bounds;
	
	import tv.turbodrive.utils.geom.RectangleRotation;

	public class TriPosSprite3D extends ObjectContainer3D
	{
		private var _src:Object3D
		private var _width:Number = 0
		private var _height:Number = 0
		private var _h2:Number = 0
		private var _w2:Number = 0
		private var _s1:Sprite3D
		private var _s2:Sprite3D
		private var _s3:Sprite3D
		private var _sizeSprite:int = 8
			
		public var id:int = -1
		private var _commonZ:Number = 0//-20
			
		private var _col:Number;
		private var _rectangle:RectangleRotation;
	
		private var _srcplanceMesh:PlaneMesh;
		private var _scaleXsp:Number = 1
		private var _scaleYsp:Number = 1
		
		/**** TODO >> REFACTORISER CETTE CLASSE *******/
		
		public function TriPosSprite3D(name:String, color:Number = 0x00FF00)
		{
			this.name = name, 
			_col = color;
			visible = false
			this.addEventListener(Object3DEvent.SCENE_CHANGED, init)		
		}
		
		public function get activated():Boolean
		{
			return Boolean(_width > 0 && _height > 0 && _s1)
		}
				
		public function setSource(src:Object3D = null, width:int = -1, height:int = -1):void
		{
			_src = src
			if(_width == 0 && width > 0) _width = width
			if(_height == 0 && height > 0) _height = height		
			getSize();
		}
		
		protected function init(event:Object3DEvent):void
		{
			if(!parent){
				this.removeEventListener(Object3DEvent.SCENE_CHANGED, init)
				if(_srcplanceMesh) _srcplanceMesh.removeEventListener(PerspScaleMesh.UPDATE_PERSP_SCALE, update)
			}

			_s1 = new Sprite3D(new ColorMaterial(_col), _sizeSprite,_sizeSprite)
			_s2 = new Sprite3D(new ColorMaterial(_col), _sizeSprite,_sizeSprite)
			_s3 = new Sprite3D(new ColorMaterial(_col), _sizeSprite,_sizeSprite)
				
			addChild(_s1)
			addChild(_s2)
			addChild(_s3)	
				
			update()
		}
		
		public function get width():Number
		{
			getSize()
			return _width
		}
		
		private function getSize():void
		{
			if(_width == 0 || _height == 0){
				if(_src){
					if(_src is PlaneMesh){
						if(!_srcplanceMesh){
							_srcplanceMesh = PlaneMesh(_src)
							_srcplanceMesh.addEventListener(PerspScaleMesh.UPDATE_PERSP_SCALE, update)
						}
						_width = _srcplanceMesh.width*_srcplanceMesh.internalPerspScale
						_height = _srcplanceMesh.height*_srcplanceMesh.internalPerspScale
					}else if(_src is Mesh){
						Bounds.getMeshBounds(Mesh(_src))
						_width = Bounds.width
						_height = Bounds.height
					}
				}
			}
			_w2 = _width*0.5
			_h2 = _height*0.5
		}
		
		public function update(e:Event = null):void
		{
			if(!_s1) return			
				
			getSize();
			
			if(_srcplanceMesh){
				_width = _srcplanceMesh.width*_srcplanceMesh.internalPerspScale
				_height = _srcplanceMesh.height*_srcplanceMesh.internalPerspScale
			}else if(_src is Mesh){
				_scaleXsp = Mesh(_src).scaleX
				_scaleYsp = Mesh(_src).scaleY
			}
			
			_w2 = _width*0.5*_scaleXsp
			_h2 = _height*0.5*_scaleXsp
			
			if(_src){
				position = _src.position.clone();
				rotationZ = _src.rotationZ
			}
			
			_s1.position = new Vector3D(-_w2,_h2,0);
			_s2.position = new Vector3D(-_w2,-_h2,0);
			_s3.position = new Vector3D(_w2,-_h2,0);
		}
		
		public function get rectangle():RectangleRotation
		{
			return _rectangle
		}
		
		public function processRectangle(view:View3D):RectangleRotation
		{	
			var v1:Vector3D = view.project(_s1.scenePosition.clone())
			var v2:Vector3D = view.project(_s2.scenePosition.clone())
			var v3:Vector3D = view.project(_s3.scenePosition.clone())
			var rectangle:RectangleRotation = new RectangleRotation();
			rectangle.createFromVector3D(v1,v2,v3)
			rectangle.id = id
			_rectangle = rectangle
				
			return rectangle
		}
	}
}