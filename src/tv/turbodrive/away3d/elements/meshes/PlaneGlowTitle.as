package tv.turbodrive.away3d.elements.meshes
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quad;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import away3d.core.base.Geometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.events.Object3DEvent;
	import away3d.materials.MaterialBase;
	import away3d.primitives.PlaneGeometry;
	
	import tv.turbodrive.away3d.elements.entities.PlaneMesh;
	import tv.turbodrive.away3d.materials.ATMaterial;
	
	public class PlaneGlowTitle extends Mesh
	{
		protected var _atlasArea:Rectangle
		private var _initTextureWidth:int = 1024	
		private var _initTextureHeight:int = 1024
		
		private var _width:Number
		private var _height:Number
			
		protected var _scX:Number = 1;
		protected var _scZ:Number = 1;
		
		protected var _externalUvOffset:Point = new Point(0,0);
		private var _targetX:Number
		public var progressX:Number = 0
		private var inc:int = 0
		
		private var _removeAtEnd:Boolean;
		public function PlaneGlowTitle(material:MaterialBase=null, idArea:String=null)
		{
			
			material.blendMode = BlendMode.ADD			
			addEventListener(Object3DEvent.SCENE_CHANGED, sceneChangedHandler)
			
			super(new PlaneGeometry(2, 2, 1,1, false ), material);
			if(idArea) setAtlasName(idArea)
		}
		
		public function setAtlasName(idArea:String):void
		{
			if(idArea){
				if(idArea == PlaneMesh.WHOLE_TEXTURE){
					// the whole texture area
					_atlasArea = new Rectangle(0,0,_initTextureWidth,_initTextureHeight);
				}else{
					/*if(_rawBounds){
					_atlasArea =  ATMaterial(material).rawCoords[idArea]
					}else{*/
					_atlasArea = ATMaterial(material).coordinates[idArea]
					//}
				}					
				_width = _atlasArea.width
				_height = _atlasArea.height
				var geom:PlaneGeometry = this.geometry as PlaneGeometry
				geom.width = _width
				geom.height = _height
				
				adjustUVs(_atlasArea,1024,1024)
			}
		}
		
		protected function sceneChangedHandler(event:Object3DEvent):void
		{
			removeEventListener(Object3DEvent.SCENE_CHANGED, sceneChangedHandler)
			rotationY = -90
			z = -50
			scale(20.5);
		}
		
		public function get targetX():Number
		{
			return _targetX;
		}

		public function set targetX(value:Number):void
		{
			_targetX = value;
			progressX = x = _targetX+16000
		}

		public function adjustUVs(atlasArea:Rectangle = null, textureWidth:int = 512, textureHeight:int = 512):void{
			textureWidth = textureWidth > -1 ? textureWidth : _initTextureWidth
			textureHeight = textureHeight > -1 ? textureHeight : _initTextureHeight
			//scaleTexX = scaleTexX > -1 ? scaleTexX : _scaleTexX
			//scaleTexY = scaleTexY > -1 ? scaleTexY : _scaleTexY			
			
			if(!atlasArea) atlasArea = new Rectangle(0,0,textureWidth,textureHeight)
				
			var subMesh:SubMesh = subMeshes[0] as SubMesh
			subMesh.scaleU = atlasArea.width / textureWidth * _scX
			subMesh.scaleV = atlasArea.height / textureHeight * _scZ
			subMesh.offsetU = (atlasArea.x+_externalUvOffset.x) / textureWidth
			subMesh.offsetV = (atlasArea.y+_externalUvOffset.y) / textureHeight
		}
		
		public function play(delay:Number = 0, removeAtEnd:Boolean = true):void{
			_removeAtEnd = removeAtEnd
			// time 0.56
			inc = 0
			TweenMax.to(this,1,{delay:delay, progressX:_targetX, ease:Quad.easeIn, onUpdate:updateX, onComplete:complete})
		}
		
		public function updateX():void
		{
			inc++
			x = progressX		
		}
		
		public function complete():void
		{
			x = _targetX
			if(_removeAtEnd && parent){
				parent.removeChild(this)
			}else{
				TweenMax.to(material,0.5,{delay:0.6, alpha:0.8})
				dispatchEvent(new Event(Event.COMPLETE));
			}			
		}
	}
}