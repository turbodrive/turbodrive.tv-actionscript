package tv.turbodrive.puremvc.mediator
{
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import tv.turbodrive.puremvc.proxy.SwitchPageProxy;
	
	public class StageMediator extends Mediator implements IMediator
	{
		static public const NAME:String = "StageMediator"
			
		private var _main:Sprite
		private var _lv0:Sprite = new Sprite();
		private var _lv1:Sprite = new Sprite();
		private var _lv2:Sprite = new Sprite();
		private var _lv3:Sprite = new Sprite();
		
		public function StageMediator(viewComponent:Object=null)
		{
			_main = Sprite(viewComponent)
			super(NAME,_main);
		}
		
		override public function onRegister():void
		{
			_main.stage.scaleMode = StageScaleMode.NO_SCALE
			_main.stage.align = StageAlign.TOP_LEFT
			_main.addChild(_lv0)
			_main.addChild(_lv1)
			_main.addChild(_lv2)
			_main.addChild(_lv3)
				
			facade.registerMediator(new Menu2DMediator(_lv3));
			facade.registerMediator(new BackButtonsMediator(_lv2));
			facade.registerMediator(new Overlay2DMediator(_lv2));
			facade.registerMediator(new Stage3DMediator(_lv0));
		}
		
		override public function listNotificationInterests():Array
		{
			return [SwitchPageProxy.INIT_FOOTER];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch(notification.getName()){
				case SwitchPageProxy.INIT_FOOTER :
					facade.registerMediator(new ShowReelMediator(_lv1));
					break;
			}
		}
	}
}