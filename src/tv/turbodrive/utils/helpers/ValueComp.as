package tv.turbodrive.utils.helpers
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import tv.turbodrive.events.NumberEvent;

	public class ValueComp extends EventDispatcher
	{
		public static const VALUE_CHANGE:String = "valueChange"
		
		private var valueTx:TextField
		private var _valueNum:Number
		
		private var plusBtn:MovieClip;
		private var moinsBtn:MovieClip;
		
		private var _increment:Number
		
		public function ValueComp(mc:MovieClip, init:Number = 0, increment:Number = 10)
		{
			valueTx = mc.val
			valueTx.addEventListener(Event.CHANGE, onChangeHandler)
			plusBtn = mc.plus
			moinsBtn = mc.moins
			moinsBtn.buttonMode = plusBtn.buttonMode = true
			value = init
			plusBtn.addEventListener(MouseEvent.MOUSE_DOWN, clickPlusHandler)
			plusBtn.addEventListener(MouseEvent.MOUSE_UP, releasePlusHandler)
			plusBtn.addEventListener(MouseEvent.RELEASE_OUTSIDE, releasePlusHandler)
			moinsBtn.addEventListener(MouseEvent.MOUSE_DOWN, clickMoinsHandler)
			moinsBtn.addEventListener(MouseEvent.MOUSE_UP, releaseMoinsHandler)
			moinsBtn.addEventListener(MouseEvent.RELEASE_OUTSIDE, releaseMoinsHandler)
			_increment = increment
		}	
		
		protected function onChangeHandler(event:Event):void
		{
			value = Number(valueTx.text)
			dispatchUpdate()
		}
		
		private function dispatchUpdate():void
		{
			dispatchEvent(new NumberEvent(VALUE_CHANGE,this, value))
		}
		
		protected function clickMoinsHandler(event:MouseEvent):void
		{
			moinsBtn.addEventListener(Event.ENTER_FRAME, enterFrameMoinsHandler)
		}	
		
		protected function clickPlusHandler(event:MouseEvent):void
		{
			plusBtn.addEventListener(Event.ENTER_FRAME, enterFramePlusHandler)	
		}
		
		protected function releaseMoinsHandler(event:MouseEvent):void
		{
			moinsBtn.removeEventListener(Event.ENTER_FRAME, enterFrameMoinsHandler)
		}
		
		protected function releasePlusHandler(event:MouseEvent):void
		{
			plusBtn.removeEventListener(Event.ENTER_FRAME, enterFramePlusHandler)
			
		}
		
		protected function enterFrameMoinsHandler(event:Event):void
		{
			value -= _increment
			dispatchUpdate()
		}
		
		protected function enterFramePlusHandler(event:Event):void
		{
			value += _increment			
			dispatchUpdate()
		}
		
		public function set value(value:Number):void
		{
			_valueNum = value
			if(valueTx.text != String(_valueNum)){
				valueTx.text = String(_valueNum)
			}
		}
		
		public function get value():Number
		{
			return _valueNum
		}
	}
}