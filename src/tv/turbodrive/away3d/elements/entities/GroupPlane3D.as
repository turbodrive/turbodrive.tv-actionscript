package tv.turbodrive.away3d.elements.entities
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.display.BlendMode;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.primitives.WireframePlane;
	
	import tv.turbodrive.away3d.elements.subElements.ButtonMeshLight;
	import tv.turbodrive.away3d.elements.subElements.SkillsMenu;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.transitions.timeline.vo.Gp3DVO;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.events.InternalTransitionEvent;
	import tv.turbodrive.events.TransitionEvent;
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.mediator.view.IViewRender3D;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	import tv.turbodrive.puremvc.proxy.data.SubPageNames;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.Layout;
	
	public class GroupPlane3D extends ObjectContainer3D
	{
		public static const BUILD_COMPLETE:String = "BuildComplete"
		public static const NAVIGATE_TO_SUBPAGE:String = "showSubPage"
		
		protected var _mainAtlas:String = ""
		protected var _secondaryAtlas:String;
		protected var _mainATMaterial:ATMaterial;
		protected var _gradientMat1:ATMaterial;
		protected var _guiMat1:ATMaterial;
		
		protected var _planeMeshList:Vector.<PlaneMesh>
		protected var _planTransition:PlaneMesh;			
		
		protected var _redline:PlaneMesh;
		protected var _title:PlaneMesh;
		protected var _visuel:PlaneMesh;
		protected var _ratioX:Number;
		protected var _ratioY:Number;

		protected var _sW:Number;
		protected var _sH:Number;

		protected var _layoutRatioX:Number;
		protected var _layoutRatioY:Number;
		
		protected var _globalContainer:ObjectContainer3D = new ObjectContainer3D();

		private var containerPlanes:ObjectContainer3D;
		
		private static var _commonAssetsReady:Boolean = false;		
		protected static var _blocTrs1:Mesh;
		protected static var _blocTrs2:Mesh;
		protected var _picker:StaticLightPicker;
		private var _pl0:PointLight;
		private var _pl1:PointLight;

		private var _grid:WireframePlane;
		private var _showRedLine:Boolean;
		
		protected var _builtContent:Boolean = false			
		protected var _listElementsToAdd:Array
			
		protected var _fadeAlphaElements:Array = []
		private var _alphasMaterials:Dictionary
		
		protected var _cameraLocalRz:Number = 0;
		
		protected var _portalIn:Gp3DVO;
		protected var _portalOut:Gp3DVO;
		protected var _worldCoordinates:Gp3DVO;
		protected var _internalLoader:Gp3DVO;
		
		protected var _internalSubTransition:Dictionary = new Dictionary();
		protected var _internalSubPosGenerated:Boolean = false;
		protected var _viewRenderer:IViewRender3D;		
	
		protected var _currentSubPage:String
		protected var _targetSubPage:String
		
		protected var _materialInitialized:Boolean = false;
		public var hidden:Boolean = false;
		protected var _rX:Number = 1;
		protected var _rY:Number = 1;
		protected var _scaleVisuel:Number = 1;
		protected var _ratioPan:Boolean = true;
		
		
		public function GroupPlane3D(mainAtlas:String = null, view:IViewRender3D = null)
		{
			addChild(_globalContainer);			
			_sW = Layout.WIDTH
			_sH = Layout.HEIGHT
			
			//_showRedLine = showRedLine			
			_planeMeshList = new Vector.<PlaneMesh>();
			_mainAtlas = mainAtlas
			_worldCoordinates = new Gp3DVO({x:0,y:0,z:0,rotationX:0, rotationY:0, rotationZ:0, rigDistance:Tools3d.DISTANCE_Z_1280})
			
			_viewRenderer = view ? view : Stage3DView.instance
			_viewRenderer.addEventListener(TransitionEvent.TRANSITION_COMPLETE, transitionCompleteHandler)
			_currentSubPage = _targetSubPage = SubPageNames.MAIN
		}
		
		public function set viewRenderer(value:IViewRender3D):void
		{
			_viewRenderer = value
		}
		
		public function get viewRenderer():IViewRender3D
		{
			return _viewRenderer
		}		
		
		public function prepareSubPageTransition(transition:TransitionPageData):void
		{
			
		}
		
		protected function navigateToSubPage(subPageName:String, transitionName:String = null):void
		{
			dispatchEvent(new InternalTransitionEvent(NAVIGATE_TO_SUBPAGE, subPageName, transitionName))
		}
		
		public function get subPositionAreGenerated():Boolean
		{
			return _internalSubPosGenerated
		}
		
		public function getInternalSubPosition(key:*):Gp3DVO
		{
			return _internalSubTransition[key]
		}
		
		public function get cameraLocalRz():Number
		{
			return _cameraLocalRz
		}
		
		public function needToWaitWhenBuilt():Boolean
		{
			return false	
		}
				
		public function build():void
		{
			trace("••• BUILD - _builtContent : " + _builtContent)	
			if(_builtContent) return		
			
			initMaterial()
			createLocalScene();
			updateViewportSize();
			replaceContent();
			startLoopBuilder();		
			
			/**TO DO : change this with the new AWD load system*/
			//GroupPlane3D.prepareTransitionAssets();
			_builtContent = !needToWaitWhenBuilt();
				
			_viewRenderer.addEventListener(ViewRender3DEvent.ON_RENDER, onRender)
		}
		
		protected function initMaterial():void
		{
			_mainATMaterial = MaterialLibrary.getMaterial(_mainAtlas) as ATMaterial
			if(_mainAtlas && _mainATMaterial) _fadeAlphaElements.push(_mainATMaterial)
				
			_guiMat1 = MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI) as ATMaterial
			_fadeAlphaElements.push(_guiMat1)
		}
		
		protected function startLoopBuilder():void
		{
			
		}		

		public function isBuilt():Boolean
		{
			return _builtContent
		}		
		
		public function fadeAlpha(value:Number, delay:Number = 0):void
		{
			var i:int
			var alphaElement:*
			var duration:Number = value == 0 ? 0.3 : 0.5
			
			if(value == 0){
				_alphasMaterials = new Dictionary();
				
				for(i = 0; i<_fadeAlphaElements.length ;i++){
					alphaElement = _fadeAlphaElements[i]
					if(alphaElement is ColorMaterial) _alphasMaterials[alphaElement] = ColorMaterial(alphaElement).alpha;
					if(alphaElement is TextureMaterial) _alphasMaterials[alphaElement] = TextureMaterial(alphaElement).alpha;
					if(alphaElement is ButtonMeshLight) _alphasMaterials[alphaElement] = ButtonMeshLight(alphaElement).alpha;
					if(alphaElement is SkillsMenu) _alphasMaterials[alphaElement] = SkillsMenu(alphaElement).alpha;
				}
			}
			
			if(_alphasMaterials){
				for(i = 0; i < _fadeAlphaElements.length ; i++){
					alphaElement = _fadeAlphaElements[i]
					var targetAlpha:Number = _alphasMaterials[alphaElement]*value
					TweenMax.to(alphaElement, duration, {delay:delay, alpha:targetAlpha})
				}
			}
			hidden = (value == 0)
		}
		
		public function generateSubPagePosition(update:Boolean = false):void
		{
			_internalSubPosGenerated = true
		}
		
		private static function prepareTransitionAssets():void
		{
				
		}
		
		protected function transitionCompleteHandler(event:TransitionEvent):void
		{
			removeTransitionElements()
			replaceContent();
		}
		
		public function addPlane(planeMesh:PlaneMesh):PlaneMesh
		{			
			_globalContainer.addChild(planeMesh)
			_planeMeshList.push(planeMesh)
			return planeMesh
		}
		
		protected function createLocalScene():void
		{				

		}
		
		/****** ELEMENTS FOR TRANSITION *****/
		
		protected function createElementsForTransition():void {}
		
		public function introTransition():void
		{				
			if(containerPlanes){
				if(contains(containerPlanes)) removeChild(containerPlanes);
			}
		}
		
		public function startTransition(timelineDuration:Number = 0, transitionInfo:TransitionPageData = null):void
		{	
		}
		
		public function hideTransition(subPageName:String = null):void {}
		
		/*************************************/
		
		public function updateViewportSize():void
		{
			for(var i:int = 0; i<_planeMeshList.length;i++){
				PlaneMesh(_planeMeshList[i]).updatePosition();
			}
		}
		
		override public function get name():String
		{
			return _mainAtlas
		}	
		
		protected function mouseOutHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.AUTO
		}
		
		protected function mouseOverHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
		}
		
		protected function onRender(e:Event):void
		{
			
		}
		
		protected function replaceContent():void
		{
			//if(_title && _redline) _redline.y = _title.y -16
		}
		
		/*protected function moveContainerBackward():void
		{
			TweenMax.to(_globalContainer, 1, {z :500, x:500, rotationY:30, ease:Quad.easeInOut})
		}*/
		
		/*protected function moveContainerForward():void
		{
			TweenMax.to(_globalContainer, 1, {z :0, x :0, rotationY:0, ease:Quad.easeInOut})
		}*/		
		
		public function resizeStage(sW:Number, sH:Number):void
		{	
			_sW = sW
			_sH = sH
			_ratioX = Layout.getRatioW(sW);
			_ratioY = Layout.getRatioH(sH);
			_layoutRatioX = Layout.getSimpleRatio(_sW,1280,1920)
			_layoutRatioY = Layout.getSimpleRatio(_sH,720,1200)
			_ratioPan = (_sW/_sH) >= 1.6
			
			_rX = _sW/Layout.WIDTH
			_rY = _sH/Layout.HEIGHT
			_scaleVisuel = _rX > _rY ? _rX : _rY
			
			if(_builtContent) replaceContent();			
		}
		
		private function removeTransitionElements():void
		{
			if(contains(_blocTrs1)) removeChild(_blocTrs1)
			if(contains(_blocTrs2)) removeChild(_blocTrs2)
				
			if(_grid){
				if(contains(_grid)){
					removeChild(_grid)
				}
				_grid = null
			}
		}			
		
		override public function dispose():void
		{	
			_builtContent = false
			
			_viewRenderer.removeEventListener(ViewRender3DEvent.ON_RENDER, onRender);
			_viewRenderer.removeEventListener(TransitionEvent.TRANSITION_COMPLETE, transitionCompleteHandler)
			
			/*var i:int = 0
			for(i = 0; i<_globalContainer.numChildren ;i++){
				ObjectContainer3D(_globalContainer.getChildAt(i)).dispose();
			}
			
			for(i = 0; i<numChildren ;i++){
				ObjectContainer3D(getChildAt(i)).dispose()
			}			*/
			
			removeTransitionElements();
			
			/** LIGHTS & LIGHTPICKER */
			/*if(_picker){
				_picker.lights = []
				_picker = null
				if(_blocTrs1) _blocTrs1.material.lightPicker = null
				if(_blocTrs2) _blocTrs2.material.lightPicker = null
			}
			
		 	if(_pl0){
				if(contains(_pl0)) removeChild(_pl0)
				_pl0 = null
			}			
			if(_pl1){
				if(contains(_pl1)) removeChild(_pl1)
				_pl1 = null
			}	*/		
			
			_mainAtlas = null
			_mainATMaterial = null
			_gradientMat1 = null
			_guiMat1 = null			
			_planeMeshList = null
			_planTransition = null			
			_title  = null
			_visuel  = null
			
			super.dispose();
		}
		
		/*public function getCameraResetSpec():TweenableObject3D
		{
			return null
		}*/
		
		public function resetPosition():void
		{
			this.transform = new Matrix3D();
		}
		
		public function get worldTargetCamCoordinates():Gp3DVO
		{
			// !! Only for TargetCamera			
			var object3D:Object3D = new Object3D()
			object3D.position = worldCoordinates.position
			object3D.rotationX = worldCoordinates.rotationX
			object3D.rotationY = worldCoordinates.rotationY
			object3D.rotationZ = worldCoordinates.rotationZ
			var camPos:Vector3D = Tools3d.getCamPositionFromTarget(object3D)
			var newPos:Gp3DVO = new Gp3DVO({position:camPos, rigDistance:Tools3d.DISTANCE_Z_1280});
			newPos.target = worldCoordinates;
			newPos.rigDistance = worldCoordinates.rigDistance
				
			return newPos
		}
		
		
		public function get worldCoordinates():Gp3DVO
		{
			return _worldCoordinates
		}
		
		public function get portalIn():Gp3DVO
		{
			return _portalIn
		}
		
		public function get portalOut():Gp3DVO
		{
			return _portalOut
		}
		
		public function get internalLoader():Gp3DVO
		{
			return _internalLoader
		}
		
		public function getSubTransition(subPageName:String):String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function transitionComplete(transition:TransitionPageData):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function resume():void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function pause():void
		{
			// TODO Auto Generated method stub
			
		}
	}
}