package tv.turbodrive.away3d.elements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.events.Event;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import away3d.containers.ObjectContainer3D;
	import away3d.events.MouseEvent3D;
	
	import tv.turbodrive.away3d.elements.entities.PlanePictureProject;
	import tv.turbodrive.events.NumberEvent;
	import tv.turbodrive.loader.AssetsManager;
	
	public class PictureViewer extends ObjectContainer3D
	{
		private var _panel:PictureViewerPanel;
		private var _nameProject:String;
		private var _currentPictureId:int;

		private var _currentPicture:PlanePictureProject;
		public function PictureViewer(nameProject:String, panel:PictureViewerPanel)
		{
			_nameProject = nameProject;
			_panel = panel
			setPanelControl(panel)			
		}
		
		public function load():void
		{
			/*if(AssetsManager.instance.isJpegsProjectLoaded(_nameProject)){
				onJpegCompleteHandler(null)
			}else{
				AssetsManager.instance.addEventListener(AssetsManager.JPEG_COMPLETE,onJpegCompleteHandler)
				AssetsManager.instance.loadJpegsProject(_nameProject)
			}		*/
		}
		
		public function setPanelControl(panel:PictureViewerPanel):void
		{
			_panel = panel
		}
		
		protected function onJpegCompleteHandler(event:Event):void
		{
			AssetsManager.instance.removeEventListener(AssetsManager.JPEG_COMPLETE,onJpegCompleteHandler)
			dispatchEvent(new Event(PictureViewerEvent.VIEWER_READY))
			_panel.addEventListener(PictureViewerEvent.CLICK_BUTTON_PICTURE, clickButtonPictureHandler)
		}
				
		protected function clickButtonPictureHandler(event:NumberEvent):void
		{
			showPicture(event.getNumber())
		}
		
		private function showPicture(id:int):void
		{
			var d:Number = 0 // delay
			
			if(_currentPicture){
				hidePicture(_currentPicture)
			}else{
				d = 0.8
			}			
			_currentPicture = new PlanePictureProject(_nameProject,"picture"+id);
			_currentPicture.mouseEnabled = true
			_currentPicture.addEventListener(MouseEvent3D.CLICK, clickPictureHandler)
			_currentPicture.addEventListener(MouseEvent3D.MOUSE_OVER,overHandler);	
			_currentPicture.addEventListener(MouseEvent3D.MOUSE_OUT,outHandler);	
			addChild(_currentPicture)
			_currentPicture.x = 1500
			_currentPicture.z = 0//150
			_currentPicture.rotationX = 90
			TweenMax.to(_currentPicture,0.8,{delay:d,x:0, rotationX : "180", ease:Quart.easeOut})
			_panel.setActiveButton(id)
			_currentPictureId = id
		}
		
		protected function clickPictureHandler(event:Event):void
		{
			var nextId:int = _currentPictureId +1
			if(_currentPictureId >= 6){
				nextId = 1
			}
			showPicture(nextId)
		}
		
		private function hidePicture(pic:PlanePictureProject, animate:Boolean = true):void
		{
			
			pic.mouseEnabled = false
			pic.removeEventListener(MouseEvent3D.CLICK,clickPictureHandler);	
			pic.removeEventListener(MouseEvent3D.MOUSE_OVER,overHandler);	
			pic.removeEventListener(MouseEvent3D.MOUSE_OUT,outHandler);
			
			if(animate){
				TweenMax.to(pic,1.2,{x:-1500,rotationX : "180", ease:Quart.easeOut, onComplete:pictureHiddenComplete, onCompleteParams:[pic]})
			}else{
				pictureHiddenComplete(pic)
			}
		}	
		
		public function close():void
		{
			hidePicture(_currentPicture, true)
		}
		
		
		private function pictureHiddenComplete(pic:PlanePictureProject):void
		{
			if(contains(pic)) removeChild(pic)
		}
		
		protected function outHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.AUTO
		}
		
		protected function overHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
		}
		
		override public function dispose():void{
			if(_currentPicture){
				hidePicture(_currentPicture, false)
				_currentPicture = null
			}
			if(_panel){
				_panel.removeEventListener(PictureViewerEvent.CLICK_BUTTON_PICTURE, clickButtonPictureHandler)
				_panel = null
			}
		}		
	}
}