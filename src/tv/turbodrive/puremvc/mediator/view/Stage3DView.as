package tv.turbodrive.puremvc.mediator.view
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.entities.Sprite3D;
	import away3d.filters.BloomFilter3D;
	import away3d.materials.ColorMaterial;
	
	import tv.turbodrive.away3d.core.NavCamera;
	import tv.turbodrive.away3d.elements.FromReelGp3D;
	import tv.turbodrive.away3d.elements.GridLoadGp3D;
	import tv.turbodrive.away3d.elements.HyperDriveGp3D;
	import tv.turbodrive.away3d.elements.PageAbout;
	import tv.turbodrive.away3d.elements.PageBorgia;
	import tv.turbodrive.away3d.elements.PageGreetings;
	import tv.turbodrive.away3d.elements.PageGs;
	import tv.turbodrive.away3d.elements.PageIkaf;
	import tv.turbodrive.away3d.elements.PageIkaf2;
	import tv.turbodrive.away3d.elements.PageTl;
	import tv.turbodrive.away3d.elements.PageTot;
	import tv.turbodrive.away3d.elements.ToReelGp3D;
	import tv.turbodrive.away3d.elements.entities.AbstractProjectGp3D;
	import tv.turbodrive.away3d.elements.entities.GenericProject3D;
	import tv.turbodrive.away3d.elements.entities.GroupPlane3D;
	import tv.turbodrive.away3d.elements.meshes.GlowGenGrid;
	import tv.turbodrive.away3d.filters.PostProcessFilter;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.tools.RiggedCameraBehaviour;
	import tv.turbodrive.away3d.transitions.TransitionsEngine;
	import tv.turbodrive.away3d.transitions.TransitionsName;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.events.ContactShareEvent;
	import tv.turbodrive.events.GroupSprite3DEvent;
	import tv.turbodrive.events.InternalTransitionEvent;
	import tv.turbodrive.events.ObjectEvent;
	import tv.turbodrive.events.TransitionEvent;
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.puremvc.proxy.data.TransitionPageData;
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.helpers.ControlHelperView;
	
	public class Stage3DView extends Sprite implements IViewRender3D
	{
		public static const VIDEO_PLANE_HIDDEN:String = "videoPlaneHidden";
		public static const VIDEO_PLANE_READY:String = "VideoPlaneReady";
		public static const READY:String = "readyStage3D";
	
		private var _view:View3D;		
		private var _rCamera:NavCamera
		
		private var _mouseDown:Boolean = false;
		private var angleMaxY:Number = 30//90//45
		private var angleMaxX:Number = 60//180//90
		private var _initMsePos:Point;

		private var _sW:Number;
		private var _sH:Number;
		
		private static const CAM_ROTATION_Z:Number = -3		
		public static var PX_PERFECT_DISTANCE:Number
		
		private var _view2:View3D;	
		private var _targetPage:Page;
		private var _currentPage:Page;		
		private var _currentGp3d:GroupPlane3D;
		
		private var _gp3DClassLists:Dictionary = new Dictionary();
		private var _targetGp3D:GroupPlane3D;
		private var _fromReelGp3d:FromReelGp3D;
		private var _toReelGp3d:ToReelGp3D;
		
		private var _isRendering:Boolean = false
			
		private static var _instance:IViewRender3D;
		
		private var _ppFilter:PostProcessFilter = new PostProcessFilter();
		private var _bloomFilter:BloomFilter3D = new BloomFilter3D(15,15,.4,3,3);

		private var _transitionsEngine:TransitionsEngine;
		private var _rgcHelper:RiggedCameraBehaviour;
		private var _hyperDriveContainer:HyperDriveGp3D;
		private var _gridLoadContainer:GridLoadGp3D;
		
		public static var S3D_PROXY_WORLD:Stage3DProxy
		
		private var _screenDisable:Shape;
		private var _stage3DProxy:Stage3DProxy;
		
		public static const OPEN_VIDEOPLAYER:String = "s3d_openVideoPlayer"
		public static const UPDATE_VIDEOPLAYER:String = "s3d_updateVideoPlayer"
		public static const CLOSE_VIDEOPLAYER:String = "s3d_closeVideoPlayer"
		public static const UPDATE_3DPOSITION:String = "s3d_updateTitlePosition"
		
		public static var CLOSE_SUBPAGE:String = "s3d_closeProject";
		public static var OPEN_SUBPAGE:String = "s3d_openProject";
		
		private var _controlHelper:ControlHelperView = new ControlHelperView()
		
		public function Stage3DView(requires:SingletonEnforcer)
		{	
			if (!requires) throw new Error("Stage3DView is a singleton, use static instance.");
			
			_gp3DClassLists["tot"] = PageTot;
			_gp3DClassLists["tl"] = PageTl
			_gp3DClassLists["borgia"] = PageBorgia
			_gp3DClassLists["ikaf"] = PageIkaf
			_gp3DClassLists["ikaf2"] = PageIkaf2
			_gp3DClassLists["gs"] = PageGs
			_gp3DClassLists["about"] = PageAbout
			_gp3DClassLists["greetings"] = PageGreetings
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		static public function get instance():IViewRender3D 
		{
			if (!_instance) _instance = new Stage3DView(new SingletonEnforcer());
			return _instance;
		}
		
		public function get pxPerfectDistance():Number
		{
			return Stage3DView.PX_PERFECT_DISTANCE
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			_controlHelper.addEventListener(ControlHelperView.UPDATED_TRANSFORM, updatedTransformHandler)
			//parent.addChild(_controlHelper);
			_controlHelper.y = 450
			_controlHelper.x = 0
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			stage.addEventListener(Event.RESIZE, resizeStageHandler);
		}	
		protected function updatedTransformHandler(event:ObjectEvent):void
		{
			
			var transformMatrix:Matrix3D = AbstractProjectGp3D.getMatrixFromCam(new Vector3D(navCamera.x, navCamera.y, navCamera.z), new Vector3D(navCamera.rotationX, navCamera.rotationY, navCamera.rotationZ))
			_currentGp3d.transform = transformMatrix
			/*var rotOffset:Vector3D = event.getObject() as Vector3D
			navCamera.rotationX += rotOffset.x
			navCamera.rotationY += rotOffset.y
			navCamera.rotationZ += rotOffset.z*/
		}		
		
		
		protected function resizeStageHandler(event:Event = null):void
		{
			if(_view && stage){
				_initMsePos = new Point(stage.stageWidth>>1, stage.stageHeight>>1)
				_sW = stage.stageWidth
				_sH =  stage.stageHeight
				if(_sW *.5 != _sW >>1) _sW++ // corrige les callages sur demi - pixels
				if(_sH *.5 != _sH >>1) _sH++ // corrige les callages sur demi - pixels
				_view.width = _sW
				_view.height = _sH
				if(_stage3DProxy){
					_stage3DProxy.width = _sW
					_stage3DProxy.height = _sH
				}
				//var ratio:Number = (_sH/_sW)
				//var fov:Number = (ratio*35.130)+20
				_rCamera.setFieldOfView(((_sH/_sW)*35.130)+20);					
				PX_PERFECT_DISTANCE = Tools3d.pixelPerfectCameraValue(_view.camera,_view.height)
				_rCamera.setOffsetZCamera(PX_PERFECT_DISTANCE-Tools3d.DISTANCE_Z_1280);
				_rCamera.updateViewPort(_sW, _sH)
				if(_currentGp3d) _currentGp3d.resizeStage(_sW,_sH)
			}
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			_mouseDown = false;
			_initMsePos = new Point();
			if(Mouse.cursor != MouseCursor.AUTO) Mouse.cursor = MouseCursor.AUTO
		}
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			_initMsePos = new Point(stage.mouseX,stage.mouseY);
			_mouseDown = true;
			//_initMsePos = new Point(stage.stageWidth>>1, stage.stageHeight>>1)
		}	
		
		public function get s3dProxy():Stage3DProxy
		{
			return _view.stage3DProxy
		}
		
		public function initView3D(stage3dProxy:Stage3DProxy = null):void
		{	
			// VIEW
			_view = new View3D();
			if(stage3dProxy){
				_stage3DProxy = stage3dProxy
				_view.stage3DProxy = stage3dProxy
				_view.shareContext = true
			}
			_view.addEventListener(Event.ADDED_TO_STAGE, view3DAddedToStageHandler)
			_view.rightClickMenuEnabled = false
			//_view.backgroundColor = 0x221026;
			//_view.backgroundColor = 0x0000FF;
			//_view.antiAlias = 4
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler)
			//stage.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler)
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler)
			mouseEnabled = mouseChildren = true
			

			// CAMERA
			_rCamera = new NavCamera(_view.camera)
			_rCamera.rigDistance = Tools3d.DISTANCE_Z_1280
			_controlHelper.setObject(_rCamera);
			//_rCamera.addEventListener(GridMenu.CLICK_BUTTON, clickButtonGridMenuHandler)
			_view.scene.addChild(_rCamera)
			
			// RIGCAM HELPER
			_rgcHelper = new RiggedCameraBehaviour()
			_rgcHelper.visible = false
			_view.scene.addChild(_rgcHelper)			
			
			// HYPERDRIVE
			_hyperDriveContainer = new HyperDriveGp3D();
			_view.scene.addChild(_hyperDriveContainer);
			_hyperDriveContainer.init()
				
			// From ReelPreinit
			//_fromReelGp3d = new FromReelGp3D()
				
			// GLOWGRIDLOADER
			_gridLoadContainer = new GridLoadGp3D();
			_view.scene.addChild(_gridLoadContainer);
			
				
			// TRANSITIONS ENGINE
			_transitionsEngine = new TransitionsEngine(_rCamera, _rgcHelper, _hyperDriveContainer as GroupPlane3D, _gridLoadContainer as GroupPlane3D)
			_transitionsEngine.addEventListener(TransitionEvent.TRANSITION_STARTS, transitionStartsHandler)
			_transitionsEngine.addEventListener(TransitionEvent.TRANSITION_COMPLETE, transitionCompleteHandler)	
			_transitionsEngine.addEventListener(TransitionEvent.MULTIPART_RESUME, resumeMultiPartHandler)
			_transitionsEngine.addEventListener(TransitionEvent.FIRSTOFMULTI_COMPLETE, firstOfMultiPartHandler)
				
			this.addChild(_view);
			
			// 2ème vue, pour les transitions
			/*_view2 = new View3D();
			_view2.scene = _view.scene
			_view2.width = 1280
			_view2.height = 720
			_view2.y = 720
			var cam2:Camera3D = _view2.camera
			cam2.x = -200
			cam2.z = -200
			
			this.addChild(_view2);*/					
			
			
			resizeStageHandler();
				
			//_view.filters3d = [new PostProcessFilter()];
			//new BloomFilter3D(15,15,.8,0.2,3)
			//_view.filters3d = []
			//setTimeout(activateBloomFilter,5000)
			//setTimeout(resizeStageHandler, 5500);
		}	
		
		protected function view3DAddedToStageHandler(event:Event):void
		{
			_view.removeEventListener(Event.ADDED_TO_STAGE, view3DAddedToStageHandler);
			resizeStageHandler();				
			
			//var stats:AwayStats = new AwayStats(_view);
			//DisplayObjectContainer(this.root).addChild(stats);
			//stats.mouseEnabled = stats.mouseChildren = false
			
			S3D_PROXY_WORLD = _view.stage3DProxy
			resumeRenderer()
			setTimeout(pauseAndReady, 50);
		}
		
		protected function transitionStartsHandler(event:TransitionEvent):void
		{
			dispatchEvent(event.clone());
		}
		
		protected function transitionCompleteHandler(event:TransitionEvent):void
		{
			//desactivateBloomFilter()
			//trace("_currentPage > " + _currentPage)
			//trace("_targetPage > " + _targetPage)
			/*if(_currentGp3d && _currentGp3d is FromReelGp3D){
				trace("pas de dispose pour FromReel3D")
				if(_currentGp3d.parent) _view.scene.removeChild(_currentGp3d);
			}else */if(_currentGp3d && _targetPage.name != _currentPage.name){
				_currentGp3d.dispose();
				_currentGp3d.removeEventListener(GroupPlane3D.NAVIGATE_TO_SUBPAGE, navigateToSubPageHandler)
				_currentGp3d.removeEventListener(ContactShareEvent.OPEN_CONTACT_PANEL, openContactPanelHandler)
				_currentGp3d.removeEventListener(AbstractProjectGp3D.UPDATE_3DPOSITION, update3DPosition)
				_currentGp3d.removeEventListener(AbstractProjectGp3D.OPEN_SUBPAGE, openSubPageHandler)
				_currentGp3d.removeEventListener(AbstractProjectGp3D.CLOSE_SUBPAGE, closeSubPageHandler)
			}
			
			_currentPage = _targetPage
			_currentGp3d = _targetGp3D
			if(_targetPage.environment == PagesName.REEL){
				//_currentGp3d.dispose()
				pauseRenderer()
			}
			dispatchEvent(event.clone());
		}		
		
		private function getRect2d(ref1:Vector3D, ref2:Vector3D):Rectangle
		{
			var point1:Vector3D = _view.project(ref1)
			var point2:Vector3D = _view.project(ref2)
			return new Rectangle(point1.x, point1.y, point2.x - point1.x, point2.y-point1.y);
		}
		
		protected function firstOfMultiPartHandler(event:Event):void
		{
			dispatchEvent(event.clone())
		}
		
			
		
		/*protected function updateVideoPlayerHandler(event:MultiVector3DEvent):void
		{
			dispatchEvent(new ObjectEvent(UPDATE_VIDEOPLAYER,this, getRect2d(event.v1,event.v2)));
		}*/
		
		/*protected function openVideoPlayerHandler(event:MultiVector3DEvent):void
		{			
			dispatchEvent(new ObjectEvent(OPEN_VIDEOPLAYER,this, {rect:getRect2d(event.v1,event.v2), id:_currentPage.id}));
		}
		
		protected function closeVideoPlayerHandler(event:Event):void
		{
			dispatchEvent(new Event(CLOSE_VIDEOPLAYER));
		}*/
		
		/*protected function clickButtonGridMenuHandler(event:Event):void
		{
			dispatchEvent(event)
		}*/
		
		
		/*public function activateBloomFilter():void
		{	
			_bloomFilter.blurX = _bloomFilter.blurY = 0
			_bloomFilter.exposure = 0
			
			if(!_view.filters3d || _view.filters3d.length == 0){
				_view.filters3d = [_bloomFilter]
			}/*else{			
				if(_view.filters3d[0] != _bloomFilter)
				{
					_view.filters3d.push(_ppFilter)
				}
			}
			TweenMax.to(_bloomFilter,0.3,{blurX:15,blurY:15,exposure:4,ease:Quad.easeInOut})
		}
		
		public function desactivateBloomFilter():void	{
			if(!_view.filters3d) return
							
			
			TweenMax.to(_bloomFilter,3,{blurX:0,blurY:0,exposure:0,ease:Quad.easeInOut, onComplete:removeFilters})
		}
		
		private function removeFilters():void
		{
			_view.filters3d = []
		}*/
		
		/*
		public function activatePPFilter():void
		{	
			if(!_view.filters3d || _view.filters3d.length == 0){
				_view.filters3d = [_ppFilter]
			}else{			
				if(_view.filters3d[_view.filters3d.length-1] != _ppFilter){
					
					_view.filters3d.push(_ppFilter)
				}
			}
		}
	
		public function desactivatePPFilter():void	{
			if(!_view.filters3d) return
			if(_view.filters3d[_view.filters3d.length-1] == _ppFilter)
			{				
				_view.filters3d.pop()
			}
		}*/
		
		private function getReelGp3D(to:Boolean = true, newPage:Page = null):GroupPlane3D
		{
			
			trace("getReelGp3D >> " + newPage)
			
			if(_toReelGp3d) _toReelGp3d.dispose();			
			if(to){
				_toReelGp3d = new ToReelGp3D(newPage);
				return GroupPlane3D(_toReelGp3d)
			}
			
			if(_fromReelGp3d) _fromReelGp3d.dispose()
			
			/*if(_fromReelGp3d){
				_fromReelGp3d.setPage(newPage)
			}else{*/
				_fromReelGp3d = new FromReelGp3D(newPage);
			//}
			return GroupPlane3D(_fromReelGp3d)
		}
		
		private function disable():void
		{
			_screenDisable = new Shape()			
		}
		
		private function initializeGp3d(_newPage:Page, to:Boolean = true):GroupPlane3D
		{
			var newGp3D:GroupPlane3D
			if(_newPage.environment == PagesName.REEL || !to){
				newGp3D = getReelGp3D(to, _newPage);
			}else {
				if(_newPage.project && _newPage.project.isSecondaryProject){
					newGp3D = new GenericProject3D(_newPage);
				}else{
					var classGp3D:Class = _gp3DClassLists[_newPage.id] as Class
					newGp3D = new classGp3D(_newPage);
				}
				newGp3D.name = _newPage.id
				newGp3D.addEventListener(GroupPlane3D.NAVIGATE_TO_SUBPAGE, navigateToSubPageHandler)
				newGp3D.addEventListener(ContactShareEvent.OPEN_CONTACT_PANEL, openContactPanelHandler)
				newGp3D.addEventListener(AbstractProjectGp3D.UPDATE_3DPOSITION, update3DPosition)
				newGp3D.addEventListener(AbstractProjectGp3D.OPEN_SUBPAGE, openSubPageHandler)
				newGp3D.addEventListener(AbstractProjectGp3D.CLOSE_SUBPAGE, closeSubPageHandler)				
			}			
			
			newGp3D.resizeStage(_sW,_sH);			
			_view.scene.addChild(newGp3D);
			return newGp3D
		}
		
		protected function closeSubPageHandler(event:Event):void
		{
			dispatchEvent(new Event(CLOSE_SUBPAGE));
		}
		
		protected function update3DPosition(event:GroupSprite3DEvent):void
		{	
			// get Rectangle rotationable calculated with the current view and the 3 sprite3Ds in the GroupSprite3d
			if(!_currentPage) return
			if(!event.groupTps3d) return
			
			event.groupTps3d.page = _currentPage
			event.groupTps3d.processRectangles(_view)
			dispatchEvent(new GroupSprite3DEvent(UPDATE_3DPOSITION, event.groupTps3d));
		}	
		
		protected function openSubPageHandler(event:GroupSprite3DEvent):void
		{
			//trace("S3D View >> openSubPageHandler " + _targetPage)
			
			if(_targetPage){
				event.groupTps3d.page = _targetPage
				if(event.groupTps3d.processRectangles(_view)){
					dispatchEvent(new GroupSprite3DEvent(OPEN_SUBPAGE, event.groupTps3d));
				}else{
					throw new Error("pas de rectangles")
				}
				
			}
		}
		
		protected function openContactPanelHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		
		public function navigationToSubPage(subPageName:String, transitionName:String = null):void
		{			
			var internalTransition:TransitionPageData = new TransitionPageData(_currentPage, _currentPage)
			// Get Internal SubTransition from targeted subPage 
			internalTransition.setInternalTransition(_currentGp3d.getSubTransition(subPageName), transitionName)
				
			if(_currentGp3d){
				_currentGp3d.prepareSubPageTransition(internalTransition)
			}
			startTransition(internalTransition)
			closeSubPageHandler(null)
		}
		
		protected function navigateToSubPageHandler(event:InternalTransitionEvent):void
		{		
			navigationToSubPage(event.internalSubPage, event.transitionName)
		}
		
		public function startTransition(info:TransitionPageData):void
		{
			resumeRenderer();
			
			
			if(! _targetPage || _targetPage.name != info.nextPage.name || _targetPage.environment != info.nextPage.environment){
				_targetPage = info.nextPage
				_targetGp3D = initializeGp3d(_targetPage);
			}
			// create ReelGp3D if we are currently in the Reel
			if((!_currentGp3d && info.previousPage && info.previousPage.environment == PagesName.REEL) || (info.previousPage && info.previousPage.environment == PagesName.REEL && info.nextPage.environment == PagesName.FOLIO))
			{
					
					//_rCamera.reset();
					_currentPage = info.previousPage
					_currentGp3d = initializeGp3d(info.nextPage, false)
			}
			
			if(info.transitionName == TransitionsName.SC_INTERNAL_LOADER){
				TweenMax.to(_grid20, 0.8, {alpha:0});
			}
			
			//activateBloomFilter()
			_transitionsEngine.play(_targetGp3D,_currentGp3d, info)
		}
		
		public static var _gridContainer:ObjectContainer3D = new ObjectContainer3D()
		private var _grid10:GlowGenGrid
		private var _grid20:GlowGenGrid
		
		private function resumeMultiPartHandler(event:TransitionEvent):void
		{
			var size:int = 1000
			
			if(_targetPage.category == PagesName.MORE_PROJECTS){
				_grid10.alpha = 0
				_grid20.alpha = 0
				_grid20.y = 0
				_grid10.y = -4000
				TweenMax.to(_grid10, 1, {delay:0.5, alpha:1})
				TweenMax.to(_grid20, 1, {delay:0.5, alpha:1})
			}else if(_targetPage.category == PagesName.SELECTED_CASES){
				_grid10.alpha = 0
				_grid20.alpha = 0
				_grid20.y = -3000
				_grid10.y = 0
				//TweenMax.to(_grid10, 1, {delay:0.5, alpha:1})
				TweenMax.to(_grid20, 1, {delay:0.5, alpha:1})
			}else{
				_grid10.alpha = 0
				_grid20.alpha = 0
			}
		}
		
		private function addGrid():void
		{
			if(_gridContainer.numChildren == 0){
				var size:Number = 1024
				_grid10 = new GlowGenGrid(size*5,size+256, GlowGenGrid.GRADIENT); 
				_grid10.y = 0
				_grid20 = new GlowGenGrid(size*5,size+256, GlowGenGrid.GRADIENT);
				//_grid20.y = 3000
				//_grid20.rotationY = _grid10.rotationY = 0
				
				_grid10.scale(20)
				_grid20.scale(20)
				//_grid10.z = _grid20.z = 30000
				_gridContainer.addChild(_grid10);
				_gridContainer.addChild(_grid20);
				_grid20.alpha = 0
				_grid10.alpha = 0
				scene.addChild(_gridContainer)
					
				// sprites
				/*var space:int = 4000
				var max:int = 5
				var offset:int = -(space*max)/2
				for(var i:int = 0; i<max; i++){
					for(var j:int = 0; j<max; j++){
						for(var k:int = 0; k<max; k++){
							var sprt:Sprite3D = new Sprite3D(new ColorMaterial(Colors.VINTAGE_WHITE,0.4),25,25);
							sprt.position = new Vector3D(offset+(i*space), offset+(j*space), offset+(+k*space));
							scene.addChild(sprt)
						}
					}
				}*/
				
			}
			
		}
			
		public function resumeMultiPartTransition(info:TransitionPageData):void
		{			
			_transitionsEngine.resumeMultiPartTransition(info);
		}

		protected function changePageHandler(event:Event):void
		{
			dispatchEvent(event);
		}	
		
		private function pauseAndReady():void
		{
			pauseRenderer();
			dispatchEvent(new Event(READY))
		}
		
		public function pauseRenderer():void
		{
			if(!_isRendering) return
			_isRendering = false
			//this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler)
			trace("### rendering >> false")
		}
		
		public function resumeRenderer():void
		{
			if(_isRendering) return
			_isRendering = true
			//this.addEventListener(Event.ENTER_FRAME, enterFrameHandler)
			trace("### Rendering >>> true")
		}
			
		/*protected function enterFrameHandler(event:Event):void
		{
			render()
		}*/
		
		public function preRender():void
		{
			// onEnterFrame from Stage3DProxy >> Stage3DMediator
			if(_isRendering) render();
		}
		
		private function render():void
		{			
			dispatchEvent(new Event(ViewRender3DEvent.ON_RENDER));
			if(isNaN(_rCamera.rotationZ)) return
			if(mouseChildren) updateCameraView()
			_view.render();
			if(_view2)_view2.render();
		
			//if(_rCamera) _rCamera.rotationY += 1
		}
		
		private function updateCameraView():void
		{			
			var targetX:Number
			var targetY:Number
			var targetrX:Number
			var targetrY:Number
			
			if(_mouseDown){
				// Système de drag & drop
				var current:Point = new Point(stage.mouseX, stage.mouseY)
					targetrX = ((stage.mouseX - _initMsePos.x) / (_sW>>1))*angleMaxX
					if(targetrX > angleMaxX) targetrX = angleMaxX
					if(targetrX < -angleMaxX) targetrX = -angleMaxX
						
					targetrY = ((stage.mouseY - _initMsePos.y) / (_sW>>1))*angleMaxY
					if(targetrY > angleMaxY) targetrY = angleMaxY
					if(targetrY < -angleMaxY) targetrY = -angleMaxY
						
					targetX = targetY = 0;
					
					if(current.subtract(_initMsePos).length > 2){
						if(Mouse.cursor != MouseCursor.HAND) Mouse.cursor = MouseCursor.HAND
					}else{
						if(Mouse.cursor != MouseCursor.AUTO) Mouse.cursor = MouseCursor.AUTO
					}
			}else{				
				targetrX = targetrY = 0;
				targetX = targetY = 0;	
			}
			
			// ROTATION PARALLAXE				
			_view.camera.x += (-targetrX-_view.camera.x)*0.25
			_view.camera.y += (targetrY-_view.camera.y)*0.35
				
			if(_currentGp3d){
				if(_currentGp3d is AbstractProjectGp3D) AbstractProjectGp3D(_currentGp3d).dispatchUpdatePosition();
			}
			
			if(_targetGp3D){
				if(_targetGp3D is AbstractProjectGp3D) AbstractProjectGp3D(_targetGp3D).dispatchUpdatePosition();
			}
			/*_view.camera.rotationY += (targetrX-_view.camera.rotationY)*0.25
			_view.camera.rotationX += (targetrY-_view.camera.rotationX)*0.25*/
		}
		
		public function get navCamera():NavCamera
		{
			return _rCamera as NavCamera
		}
		
		public function get scene():Scene3D
		{
			return _view.scene as Scene3D
		}
		
		
		/**
		 * TRIANGLE MENU
		 **/
		
		public function initConstantAssets():void
		{
			//trace("initExternalGraphics")
			//_fromReelGp3d.preInit();
			_rCamera.initExternalGraphics()
			_rCamera.updateViewPort(_sW, _sH);
			_gridLoadContainer.init();
			addGrid()
		}
		
		public function closeTriangleMenu():void
		{			
			if(_currentGp3d && _currentGp3d.hidden){
				_currentGp3d.fadeAlpha(1)
				_currentGp3d.resume();
			}
		}
		
		public function openTriangleMenu():void
		{
			//if(_rCamera && _rCamera.frontBgMaterial) TweenMax.to(_rCamera.frontBgMaterial,0.5,{alpha:1})
			if(_currentGp3d ){
				_currentGp3d.pause();
				if(!_currentGp3d.hidden) _currentGp3d.fadeAlpha(0)
			}
		}
		
		public function pauseContent():void
		{
			if(_currentGp3d) _currentGp3d.pause();
		}
		
		public function resumeContent():void
		{
			if(_currentGp3d) _currentGp3d.resume();
		}
	}
}

class SingletonEnforcer {}