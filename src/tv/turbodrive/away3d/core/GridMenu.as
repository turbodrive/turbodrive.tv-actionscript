package tv.turbodrive.away3d.core
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Entity;
	import away3d.entities.Mesh;
	import away3d.library.AssetLibrary;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	
	import tv.turbodrive.away3d.elements.MenuItem;
	import tv.turbodrive.events.ObjectEvent;
	import tv.turbodrive.events.StringEvent;
	import tv.turbodrive.puremvc.proxy.data.PagesName;

	public class GridMenu extends ObjectContainer3D
	{
	
		public static const CLICK_BUTTON:String = "clickButton"
		public static const UPDATE_POSITION:String = "updatePosition"
		
		private static const POSITIONS:Object = {
			selectedCases : new Vector3D(350,-190,800-1000-300),
			moreProjects : new Vector3D(270,30, 900-1000-300)
		}
		
		private var blackMat:ColorMaterial = new ColorMaterial(0x000000,0);
		private var _hidden:Boolean = true;
		private var zHidden:Number = -500-1000-300;
			
		private var _itemsSC:ObjectContainer3D;
		private var _itemsMP:ObjectContainer3D;
		private var _hasListeners:Boolean = false;

		private var mainGrid:Mesh;
		public static const MENU_HIDDEN:String = "MenuHidden";
		
		private var _selectedCases:Vector.<MenuItem>
		private var _moreProjects:Vector.<MenuItem>
		private var _triangleButtons:Dictionary = new Dictionary();
			
		private var _refButton1:Entity;
		private var _refButton2:Entity;
		private var _currentCategory:String
		
		public function GridMenu()
		{							
			super();
		}
		
		public function isOpen():Boolean
		{
			return (z != zHidden)
		}

		public function build():void
		{
			if(mainGrid) return			
			z = zHidden
			_hidden = true

			mainGrid = Mesh(AssetLibrary.getAsset("mainGrid"));
			var auxGrid:Mesh = Mesh(AssetLibrary.getAsset("auxGrid"));
			TextureMaterial(auxGrid.material).alpha = 0.1
			TextureMaterial(mainGrid.material).alpha = 0.5
			_itemsSC = ObjectContainer3D(AssetLibrary.getAsset("itemsSC"));
			_itemsMP = ObjectContainer3D(AssetLibrary.getAsset("itemsMP"));

			auxGrid.z -= 100			
			_selectedCases = new Vector.<MenuItem>()
			_moreProjects = new Vector.<MenuItem>()
			
			var item:MenuItem
			var ent:Entity
			for(var i:int = 0; i< _itemsSC.numChildren ; i++){
				ent = _itemsSC.getChildAt(i) as Entity				
				if(ent is Mesh){
					item = new MenuItem(Mesh(ent))
					item.addEventListener(MenuItem.BLINK_COMPLETE, blinkChangePageHandler)
					_selectedCases.push(item)
					_triangleButtons[item.name] = item
						
				}
			}	
			for(i = 0; i< _itemsMP.numChildren ; i++){
				ent = _itemsMP.getChildAt(i) as Entity
				if(ent.name == "xmasButton") _refButton1 = ent
				if(ent.name == "teotwButton") _refButton2 = ent
				if(ent is Mesh){
					item = new MenuItem(Mesh(ent))
					item.addEventListener(MenuItem.BLINK_COMPLETE, blinkChangePageHandler)
					_moreProjects.push(item)
					_triangleButtons[item.name] = item
				}
			}
				
			addChild(mainGrid)
			addChild(auxGrid)
			addChild(_itemsSC)
			addChild(_itemsMP)
		}
		
		protected function blinkChangePageHandler(event:StringEvent):void
		{
			dispatchEvent(new StringEvent(GridMenu.CLICK_BUTTON,this,event.getString()));
		}		
		
		private function darker():void
		{
			if(blackMat.alpha >= 0.37) return
			TweenMax.to(blackMat,0.8,{alpha:0.37, ease:Quad.easeOut})
		}
		
		private function lighter():void
		{
			TweenMax.to(blackMat,0.4,{delay:0.6, alpha:0, ease:Quad.easeIn})
		}		
		
		public function hide(duration:Number = 0.8):void
		{
			TweenMax.to(this,duration,{z:zHidden, ease:Quart.easeOut, onComplete:menuHidden})
			udpateItemVisibility(null, duration*.5)
		}
		
		public function menuHidden():void
		{
			dispatchEvent(new Event(MENU_HIDDEN))
		}
		
		public function show(category:String):void
		{
			var position:Vector3D = POSITIONS[category]	
			var duration:Number
			var params:Object
			var delayItem:Number = 0
			if(!isOpen()){
				delayItem = 0.4
				duration = 0.6
				params = {x:position.x, y:position.y, z:position.z, ease:Expo.easeOut, onUpdate:updatePosition}
			}else{
				delayItem = 0.1
				duration = 0.8
				params = {x:position.x, y:position.y, z:position.z, ease:Quad.easeInOut, onUpdate:updatePosition}
			}			
		
			params.delay = 0			
			TweenMax.to(this,duration,params)		
			udpateItemVisibility(category, delayItem)
		}
		
		private function udpateItemVisibility(category:String = null, delayItem:Number = 0.25):void
		{
			if(!_selectedCases) return
			
			_currentCategory = category
				
			var i:int
			var item:MenuItem			
			for(i = 0; i<_selectedCases.length; i++){
				item = _selectedCases[i]
				if(category == PagesName.SELECTED_CASES){
					item.show(delayItem + Math.random()*0.4)
				}else{
					item.hide(delayItem)
				}
			}
			for(i = 0; i<_moreProjects.length; i++){
				item = _moreProjects[i]
				if(category == PagesName.MORE_PROJECTS){
					item.show(delayItem+ Math.random()*0.4)
				}else{
					item.hide(delayItem)
				}
			}	
		}
		
		public function dispatchUpdatePosition():void
		{
			updatePosition()
		}
			
		
		private function updatePosition():void
		{
			if(!_refButton1 || !_refButton2) return
			dispatchEvent(new ObjectEvent(UPDATE_POSITION,this,{ref1:_refButton1.scenePosition, ref2:_refButton2.scenePosition}))
		}		
		
		public function highlightButton(pageName):void
		{
			
			MenuItem(_triangleButtons[pageName]).over()
			var otherButtonList:Vector.<MenuItem> = _currentCategory == PagesName.MORE_PROJECTS ? _moreProjects : _selectedCases
			for(var i:int = 0; i < otherButtonList.length; i++){
				var item:MenuItem = otherButtonList[i];
				if(item.name != pageName) item.nonOver()
			}
		}
		
		public function downlightButton(pageName):void
		{
			MenuItem(_triangleButtons[pageName]).out()
			var otherButtonList:Vector.<MenuItem> = _currentCategory == PagesName.MORE_PROJECTS ? _moreProjects : _selectedCases
			for(var i:int = 0; i < otherButtonList.length; i++){
				var item:MenuItem = otherButtonList[i];
				if(item.name != pageName) item.nonOut()
			}
		}
		
		public function clickBlink(id:String):void
		{
			if(_triangleButtons && _triangleButtons[id]) MenuItem(_triangleButtons[id]).blink();			
		}
	}
}