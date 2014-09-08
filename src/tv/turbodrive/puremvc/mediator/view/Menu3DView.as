package tv.turbodrive.puremvc.mediator.view
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.setTimeout;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DProxy;
	import away3d.materials.methods.ColorTransformMethod;
	import away3d.primitives.PlaneGeometry;
	
	import tv.turbodrive.away3d.core.GridMenu;
	import tv.turbodrive.away3d.core.NavCamera;
	import tv.turbodrive.away3d.elements.entities.PerspScaleMesh;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialHelper;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.away3d.utils.Tools3d;
	import tv.turbodrive.events.ObjectEvent;
	import tv.turbodrive.events.ViewRender3DEvent;
	import tv.turbodrive.puremvc.mediator.view.component.MenuHeader;
	import tv.turbodrive.puremvc.proxy.data.Page;
	import tv.turbodrive.puremvc.proxy.data.PagesName;
	import tv.turbodrive.utils.Layout;
	
	public class Menu3DView extends View3D implements IViewRender3D
	{
		private var _gridMenu:GridMenu;

		private var tempRd:Number = -3000//995.6
	
		private static var _instance:IViewRender3D;
		
		private var _navCamera:NavCamera;
		private static var PX_PERFECT_DISTANCE:Number;

		private var _violetBgCopy:ATMaterial;
		private var _rendering:Boolean = true
		private var _darkBg:PerspScaleMesh

		public static const MENU_OPEN:String = "menuOpen";
		public static const MENU_MOVE:String = "menuMove";

		private var _sH:uint;
		private var _sW:uint;
		private var _mainContainer:ObjectContainer3D = new ObjectContainer3D();
		private var _menu3DOpen:Boolean = false
				
		public function Menu3DView(stage3DProxy:Stage3DProxy)
		{
			super(null, null, null, false, "baseline");
			this.stage3DProxy = stage3DProxy
			shareContext = true
			_gridMenu = new GridMenu();
			
			_navCamera = new NavCamera(camera)
			_navCamera.rigDistance = Tools3d.DISTANCE_Z_1280
			_mainContainer.z = tempRd
			// _navCamera >> afficher le fond en plus sombre (initExternal2...), et seulement une partie, en fond du header.
				
			scene.addChild(_navCamera)
			mouseChildren = mouseEnabled = false
				
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
		}
		
		public function get pxPerfectDistance():Number
		{
			return Menu3DView.PX_PERFECT_DISTANCE
		}
		
		public function get navCamera():NavCamera
		{
			return _navCamera
		}
		
		public function get s3dProxy():Stage3DProxy
		{
			return stage3DProxy
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler)
			stage.addEventListener(Event.RESIZE, resizeStageHandler);
			resizeStageHandler();
			setTimeout(resizeStageHandler,5000);
		}
		
		public function initConstantAssets():void
		{
			_navCamera.z = _mainContainer.z
			_gridMenu.addEventListener(GridMenu.MENU_HIDDEN, menuHiddenHandler)
			_gridMenu.addEventListener(GridMenu.CLICK_BUTTON, clickButtonMenuHandler)
			_gridMenu.addEventListener(GridMenu.UPDATE_POSITION, updateMenuPositionHandler)
			_gridMenu.build()
			_mainContainer.addChild(_gridMenu);
			var _violetBgMaterial:ATMaterial = MaterialHelper.cloneATMaterial(MaterialLibrary.getMaterial(MaterialName.VIOLETBG));
			var colorTransformMethod:ColorTransformMethod = new ColorTransformMethod()
			var cT:ColorTransform = new ColorTransform(0.63,.63,.63)
			colorTransformMethod.colorTransform = cT;
			_violetBgMaterial.addMethod(colorTransformMethod);
			_darkBg = new PerspScaleMesh(new PlaneGeometry(1280,720,1,1, false), _violetBgMaterial, this)
			_darkBg.adjustUVs(new Rectangle(0,0,1024,576),_violetBgMaterial.width,_violetBgMaterial.height)
			_darkBg.z = 1000;
			//_darkBg.visible = false
			_mainContainer.addChild(_darkBg)
			scene.addChild(_mainContainer);
			
			height = MenuHeader.HEIGHT_OUT
			y = -720-500
			resizeStageHandler();
			_rendering = true
				
			_gridMenu.show(PagesName.SELECTED_CASES)
			setTimeout(initEnd,500)
	
		}
		
		private function initEnd():void 
		{
			_gridMenu.hide(1);			
			setTimeout(switchVisible,1100)			
		}
		
		private function switchVisible():void
		{
			_gridMenu.visible = true
			//_darkBg.visible = true
			y = 0
			_darkBg.updatePosition();
		}		
		
		protected function updateMenuPositionHandler(event:ObjectEvent):void
		{
			var ref1:Vector3D = event.getObject().ref1
			var ref2:Vector3D = event.getObject().ref2
			var point1:Vector3D = project(ref1)
			var point2:Vector3D = project(ref2)
			var rect:Rectangle = new Rectangle(point1.x, point1.y+_offsetCameraY, point2.x - point1.x, point2.y-point1.y+_offsetCameraY);
			dispatchEvent(new ObjectEvent(MENU_MOVE,this, rect));
		}
		
		protected function menuHiddenHandler(event:Event):void
		{
			//_rendering = false			
		}
		
		override public function render():void
		{
			if(_rendering){
				super.render()
				dispatchEvent(new Event(ViewRender3DEvent.ON_RENDER));
			}
		}
		
		private function get _offsetCameraY():Number
		{
			if(height == _sH) return 0
			return (_sH-height)/2
		}
		
		protected function resizeStageHandler(event:Event = null):void
		{
			_sW = stage.stageWidth
			_sH =  stage.stageHeight
			width = _sW
				
			if(_menu3DOpen) height = _sH
			
			var rX:Number = _sW/1280
			var rY:Number = _sH/720
			var scaleVisuel:Number = rY
			if(rX > rY){
				scaleVisuel = rX
			}
			if(_darkBg) _darkBg.extraScale = scaleVisuel
				
			updateOpenMenu();
		}
		
		public function updateState(page:Page):void
		{
	
			if(page.id != PagesName.INTRO && page.id != PagesName.REEL ){
				if(_darkBg){
					_darkBg.visible = true
				}
			}else {
				if(_darkBg) _darkBg.visible = false
			}
		}
		
		public function updateCameraSettings():void
		{
			_navCamera.setFieldOfView(((height/_sW)*35.130)+20);
			PX_PERFECT_DISTANCE = Tools3d.pixelPerfectCameraValue(camera,height)
			_navCamera.setOffsetZCamera(PX_PERFECT_DISTANCE-Tools3d.DISTANCE_Z_1280);
			_navCamera.y = _offsetCameraY
			var _layoutRatioX:Number = Layout.getSimpleRatio(_sW,Layout.WIDTH,1920)
			var _layoutRatioY:Number = Layout.getSimpleRatio(_sH,Layout.HEIGHT,1200)
			_navCamera.z = -3000 + _layoutRatioX*300
			_gridMenu.dispatchUpdatePosition()
		}
		
		private function clickButtonMenuHandler(e:Event):void
		{
			dispatchEvent(e)
		}
		
		public function enableTriangleMenu(category:String):void
		{	
			_rendering = true
			_gridMenu.show(category)
			if(!_gridMenu.isOpen()){
				_gridMenu.addEventListener(GridMenu.CLICK_BUTTON, clickButtonMenuHandler)
				if(_violetBgCopy) TweenMax.to(_violetBgCopy,0.5, {alpha:1, onComplete:onCompleteOpen})
			}
			TweenMax.to(this, .5, {height:_sH, ease:Quart.easeOut, onUpdate:updateOpenMenu})
			_menu3DOpen = true
		}
		
		public function updateOpenMenu():void
		{
			updateCameraSettings();
			if(_darkBg) _darkBg.updatePosition();
		}		
		
		public function onCompleteOpen():void
		{			
			dispatchEvent(new Event(MENU_OPEN))	
		}
		
		public function disableTriangleMenu():void
		{	
			TweenMax.to(this, .5, {height:MenuHeader.HEIGHT_OUT, ease:Quart.easeOut, onUpdate:updateOpenMenu})
			if(_gridMenu.isOpen()){
				_gridMenu.removeEventListener(GridMenu.CLICK_BUTTON, clickButtonMenuHandler)
				_gridMenu.hide();
			}
			_menu3DOpen = false
		}
		
		public function rollOverTriangle(pageName):void
		{
			_gridMenu.highlightButton(pageName)
		}
		
		public function rollOutTriangle(pageName):void
		{
			_gridMenu.downlightButton(pageName)
		}
		
		public function clickTriangle(pageName):void
		{
			_gridMenu.clickBlink(pageName)
		}
		
		public function slideDownFromHeader():void
		{
			if(_menu3DOpen) return
			TweenMax.to(this, .3, {height:MenuHeader.HEIGHT_OVER, ease:Quart.easeOut, onUpdate:updateOpenMenu})
		}
		
		public function slideUpFromHeader():void
		{
			if(_menu3DOpen) return
			TweenMax.to(this, .3, {height:MenuHeader.HEIGHT_OUT, ease:Quart.easeOut, onUpdate:updateOpenMenu})
			
		}
	}
}