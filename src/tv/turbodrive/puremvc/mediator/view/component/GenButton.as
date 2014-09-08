package tv.turbodrive.puremvc.mediator.view.component
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import tv.turbodrive.utils.Colors;
	import tv.turbodrive.utils.Styles;

	public class GenButton extends GenericButton
	{
		static public const LEFT:String = "pictoOnLeft"
		static public const RIGHT:String = "pictoOnRight"
			
		static public const PLAIN_RED:String = "plainRed"
		static public const WIREFRAME_GREY:String = "wireframeGrey"
			
		static public const ARROW_PICTOGRAM:String ="arrowPicto"
		static public const INFO_PICTOGRAM:String ="infoPicto"
		static public const EXTERNAL_LINK_PICTOGRAM:String ="externalLinkPicto"
		static public const DOWNARROW2_PICTOGRAM:String ="downArrow2Picto"
		static public const CROSS_PICTOGRAM:String ="crossPicto"
			
			
		private var _style:String	
		private var _pictoLocation:String;
		private var _picto:String;
		private var _wireframe:Sprite

		private var textField:TextField;
		
		public function GenButton(text:String, style:String = "plainRed", pictoLocation:String = null, picto:String = null)
		{
			buttonMode = true
			mouseChildren = false
			mouseEnabled = true
				
			_style = style			
			
			_pictoLocation = pictoLocation ? pictoLocation : LEFT
			_picto = picto ? picto : ARROW_PICTOGRAM
			
			textField = Styles.createButtonField("<buttonText11Bold>"+text+"</buttonText11Bold>", true);
			addChild(textField)
			textField.y = 3.90
			textField.autoSize = TextFieldAutoSize.LEFT
			textField.x = _pictoLocation == LEFT ? 23 : 5
			picto_mc.x = _pictoLocation == LEFT ? 4 : (textField.x+textField.width+2)
			textField.y = 6.60
			picto_mc.y = 4
			picto_mc.gotoAndStop(_picto)
				
			this.addEventListener(Event.ENTER_FRAME, enterFrameHandler)	
			this.addEventListener(MouseEvent.ROLL_OVER, rollOverHandler)
			this.addEventListener(MouseEvent.ROLL_OUT, rollOutHandler)
			
		}
		
		protected function rollOutHandler(event:MouseEvent):void
		{
			if(_wireframe){
				TweenMax.to(textField, 0.5, {tint:Colors.MEDIUM_GREY, ease:Quart.easeOut})
				TweenMax.to(picto_mc, 0.5, {tint:Colors.MEDIUM_GREY, ease:Quart.easeOut})
				TweenMax.to(background_mc, 0.5, {tint:Colors.DARK_BLUE_GREY, alpha:0, ease:Quart.easeOut})
			}else{
				TweenMax.to(textField, 0.5, {tint:Colors.VINTAGE_WHITE, ease:Quart.easeOut})
				TweenMax.to(picto_mc, 0.5, {tint:Colors.VINTAGE_WHITE, ease:Quart.easeOut})
				TweenMax.to(background_mc, 0.5, {removeTint:true, ease:Quart.easeOut})					
			}
		}
		
		protected function rollOverHandler(event:MouseEvent):void
		{
			if(_wireframe){
				TweenMax.to(textField, 0.3, {tint:Colors.LIGHT_GREY, ease:Quart.easeOut})
				TweenMax.to(picto_mc, 0.3, {tint:Colors.LIGHT_GREY, ease:Quart.easeOut})
				TweenMax.to(background_mc, 0.3, {tint:Colors.DARK_BLUE_GREY, alpha:1, ease:Quart.easeOut})
			}else{
				TweenMax.to(textField, 0.3, {tint:Colors.MEDIUM_GREY, ease:Quart.easeOut})
				TweenMax.to(picto_mc, 0.3, {tint:Colors.MEDIUM_GREY, ease:Quart.easeOut})
				TweenMax.to(background_mc, 0.3, {tint:Colors.VINTAGE_WHITE, alpha:1, ease:Quart.easeOut})
			}
		}
		
		protected function enterFrameHandler(event:Event):void
		{
			if(textField.textWidth > 0){
				this.removeEventListener(Event.ENTER_FRAME, enterFrameHandler)
				build()
			}
		}
		
		private function build():void
		{
			background_mc.width = int(textField.width+32)
			background_mc.height = 26
			if(_style == WIREFRAME_GREY){
				_wireframe = new Sprite();
				_wireframe.graphics.lineStyle(1,0x392A3C,1,false,"normal",CapsStyle.SQUARE,JointStyle.MITER)
				_wireframe.graphics.beginFill(0x000000,0)
				_wireframe.graphics.drawRect(0,0,background_mc.width, 26)
				_wireframe.graphics.endFill();
				TweenMax.to(background_mc, 0, {tint:Colors.DARK_BLUE_GREY, alpha:0, ease:Quart.easeOut})
				TweenMax.to(textField,0,{tint:Colors.MEDIUM_GREY}) 
				TweenMax.to(picto_mc,0,{tint:Colors.MEDIUM_GREY}) 
				addChildAt(_wireframe, 0)
			}else{
				TweenMax.to(picto_mc,0,{tint:Colors.VINTAGE_WHITE}) 
			}
		}		
	}
}