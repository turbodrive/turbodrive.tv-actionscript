package tv.turbodrive.away3d.elements.subElements
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.materials.TextureMaterial;
	
	import tv.turbodrive.away3d.materials.MaterialHelper;

	public class ButtonMesh extends EventDispatcher
	{
		public static const FRAMERATE:int = 30

		private var _sourceMesh:Mesh		
		private var _enabled:Boolean = false
		private var _alpha:Number = 1
		public var stepOffsetU:Number = 0
		public var stepOffsetV:Number = 0
		
		public var showSequence:Array = []
		public var overSequence:Array = []
		public var outSequence:Array = []
		public var downSequence:Array = []
		public var upSequence:Array = []
		public var alphaFrame:Array = []
			
		private var _currentSequence:Array
			
		private var _animatedSpriteSheetDirection:String;
		private var _frame:uint = 0;
		
		public var playHeadPosition:uint = 0
		
		public var name:String = "";
		
		private var alphaBlendFrame:Boolean = false
		private var alphaBlendAlpha:Boolean = false
			
		public var debug:Boolean = false
		
		
		public function ButtonMesh(sourceMesh:Mesh, duplicateMaterial:Boolean = true)
		{
			_sourceMesh = sourceMesh
			
			if(duplicateMaterial){
				var oldAlpha:Number = TextureMaterial(_sourceMesh.material).alpha
				var clonedMat:TextureMaterial = MaterialHelper.cloneTextureMaterial(_sourceMesh.material as TextureMaterial)
				_sourceMesh.material = clonedMat
				alpha = oldAlpha
			}
			enabled = true
		}
		
		private function get _sourceMaterial():TextureMaterial
		{
			return _sourceMesh.material as  TextureMaterial
		}
		
		public function set alpha(value:Number):void
		{
			_alpha = value
			if(_alpha == 1){
				alphaBlendAlpha = false
			}else{
				alphaBlendAlpha = true
			}
			
			updateAlphaBlending();
			_sourceMaterial.alpha = value
		}
		
		private function updateAlphaBlending():void
		{			
			_sourceMaterial.alphaBlending = (alphaBlendFrame || alphaBlendAlpha)
			if(debug) trace("alphaBlending > " + _sourceMaterial.name + " - " +alphaBlendFrame +" - " + alphaBlendAlpha)
				
		}
		
		public function get alpha():Number
		{
			return _alpha
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value
			_sourceMesh.mouseEnabled = _enabled
			_sourceMaterial.animateUVs = _enabled
				
			if(_enabled){				
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
				_sourceMesh.addEventListener(MouseEvent3D.MOUSE_UP, mouseUpHandler);
				_sourceMesh.addEventListener(MouseEvent3D.CLICK, mouseClickHandler);
			}else{
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.MOUSE_UP, mouseUpHandler);
				_sourceMesh.removeEventListener(MouseEvent3D.CLICK, mouseClickHandler);
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled
		}
		
		public function show(delay:Number = 0):void
		{
			playSequence(showSequence, delay)
		}
		
		protected function mouseClickHandler(event:MouseEvent3D):void
		{
			dispatchEvent(event)
		}
		
		protected function mouseUpHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
			playSequence(upSequence)
			dispatchEvent(event)			
		}
		
		protected function mouseDownHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
			playSequence(downSequence)
			dispatchEvent(event)
		}	
		
		protected function mouseOutHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.AUTO
			dispatchEvent(event)
			
			///// TODO!!
			playSequence(outSequence)
		}
		
		protected function mouseOverHandler(event:MouseEvent3D):void
		{
			Mouse.cursor = MouseCursor.BUTTON
			dispatchEvent(event)
			playSequence(overSequence)
		}
		
		private function playSequence(sequence:Array, delay:Number = 0):void
		{	
			if(stepOffsetU == 0 && stepOffsetV == 0) return
			_currentSequence = sequence
			playHeadPosition = 0
			updateFrame();	
			if(_currentSequence.length > 1) TweenMax.to(this, sequence.length*(1/FRAMERATE),{playHeadPosition:sequence.length-1, onUpdate:updateFrame, ease:Linear.easeNone})
		}
		
		private function updateFrame():void
		{
			frame = _currentSequence[playHeadPosition]
		}
		
		public function set frame(value:uint):void
		{
			_frame = value
			if(alphaFrame.length > 0) {
				for(var i:int =0; i< alphaFrame.length ;i++){
					if(alphaFrame[i] == _frame){
						alphaBlendFrame = true
					}else{
						alphaBlendFrame = false
					}
				}
			}
				
			_sourceMesh.subMeshes[0].offsetU = _frame*stepOffsetU
			_sourceMesh.subMeshes[0].offsetV = _frame*stepOffsetV
			
			updateAlphaBlending();
		}
		
		public function get frame():uint
		{
			return _frame
		}
	}
}