package tv.turbodrive.away3d.elements
{
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;
	import away3d.events.Object3DEvent;
	
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import tv.turbodrive.away3d.elements.entities.AnimatedUVMesh;
	import tv.turbodrive.away3d.materials.ATMaterial;
	import tv.turbodrive.away3d.materials.MaterialLibrary;
	import tv.turbodrive.away3d.materials.MaterialName;
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.puremvc.mediator.view.Stage3DView;
	
	public class PictureViewerPanel extends ObjectContainer3D
	{
		
		
		private var _guiMat1:ATMaterial;
		private var _title:AnimatedUVMesh;
		
		private var listBtn:Vector.<AnimatedUVMesh> = new Vector.<AnimatedUVMesh>();
		private var nbrBtn:int = 6
		private var xPos:int = -73
			
		private var _idButtons:Dictionary = new Dictionary();
		private var _currentButton:AnimatedUVMesh
		
		private var _intro:AnimatedUVMesh;
		
		public function PictureViewerPanel()
		{
			_guiMat1 = MaterialLibrary.getMaterial(MaterialName.TEXTURE_GUI) as ATMaterial
			_guiMat1.texture.getTextureForStage3D(Stage3DView.instance.s3dProxy);
			_intro = new AnimatedUVMesh(_guiMat1,"area8")
			_intro.totalframes = 10
			_intro.sequence = [2,1,2,1,3,4,5,6,7,8,9,10];
			_intro.setDirection(AnimatedUVMesh.VERTICAL);
			_intro.addEventListener(AnimatedUVMesh.COMPLETE, onCompleteIntro)		
			
			_title = new AnimatedUVMesh(_guiMat1,"area1");
			_title.x = xPos
			_title.setDirection(AnimatedUVMesh.VERTICAL);
			addChild(_intro);
			
			addChild(_title)
			_title.visible = false
			var prev:AnimatedUVMesh = _title
			for(var i:int = 2; i<nbrBtn+2 ;i++){
				var btn:AnimatedUVMesh = new AnimatedUVMesh(_guiMat1,"area"+i);
				btn.setDirection(AnimatedUVMesh.VERTICAL);
				btn.mouseEnabled = true
				_idButtons[btn] = i-1
				btn.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler)
				btn.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler)
				btn.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler)
				listBtn.push(btn)
				btn.x = prev.x + (prev.width >>1) + (btn.width>>1);
				btn.visible = false
				prev = btn
				addChild(btn)
			}			
			
			this.addEventListener(Object3DEvent.SCENE_CHANGED, sceneChangeHandler)
		}
		
		protected function sceneChangeHandler(event:Event):void
		{
			this.removeEventListener(Object3DEvent.SCENE_CHANGED, sceneChangeHandler)
			setTimeout(_intro.play, 200)			
		}
		
		protected function onCompleteIntro(event:Event):void
		{
			
			_intro.x = 50000
			_intro.removeEventListener(AnimatedUVMesh.COMPLETE, onCompleteIntro)
		
			_title.visible = true
			var l:int = listBtn.length 
			for(var i:int = 0; i<l ;i++){
				AnimatedUVMesh(listBtn[i]).visible = true
			}
			
			removeChild(_intro)
		}
		
		protected function mouseDownHandler(event:Event):void
		{			
			_currentButton = event.currentTarget as AnimatedUVMesh;
			_currentButton.frame = 3;
			dispatchEvent(new NumberEvent(PictureViewerEvent.CLICK_BUTTON_PICTURE,null,_idButtons[_currentButton]));
		}
		
		public function setActiveButton(id:int):void
		{
			if(_currentButton){
				_currentButton.frame = 1;
			}
			_currentButton = listBtn[id-1]
			_currentButton.frame = 3			
		}
		
		protected function mouseOverHandler(event:MouseEvent3D):void
		{
			_title.frame = 2
			AnimatedUVMesh(event.currentTarget).frame = 2
			Mouse.cursor = MouseCursor.BUTTON
		}
		
		protected function mouseOutHandler(event:MouseEvent3D):void
		{		
			_title.frame = 1
			AnimatedUVMesh(event.currentTarget).frame = 1
			Mouse.cursor = MouseCursor.AUTO
		}
		
		public function close():void
		{
			if(_currentButton){
				_currentButton.frame = 1;
			}
			_currentButton = null
		}
		
		override public function dispose():void
		{
			for(var i:int = 0; i< numChildren ;i++){
				var child:AnimatedUVMesh = getChildAt(i) as AnimatedUVMesh
				child.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler)
				child.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler)
				child.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler)
				removeChild(child)
			}
			_currentButton = null			
			_title = null
		}
	}
}