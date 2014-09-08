package tv.turbodrive.utils.tick 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Viseth Chum d'après Bourre (Framework Lowra)
	 */
	public class TickDispatcher extends EventDispatcher
	{
		static private var FRAMERATE:Number = 30;
		private static var _instance:TickDispatcher;
		
		public static const TICK_EVENT:String = new String('tick');
		
		private var _tickDelay:Number;
		private var _timer:Timer;
		private var _isTicking:Boolean;
		
		private var _tickListenersList:Array;
		private var _isChanging:Boolean = new Boolean(false);	
		
		//Constructeur
		public function TickDispatcher(access:PrivateConstructorAccess):void
		{
			_tickDelay = new Number();
			_tickDelay = 1000 / FRAMERATE;			
			_timer = new Timer(_tickDelay, 0);
			_timer.addEventListener(TimerEvent.TIMER, timerHandler);
			_isTicking = new Boolean(false);			
			_tickListenersList = new Array();
		}
		
		public static function getInstance():TickDispatcher
		{
			if (!_instance) _instance = new TickDispatcher(new PrivateConstructorAccess());
			
			return _instance;
		}		
		
		//Méthodes
		public function set framerate(value:int ):void
		{
			FRAMERATE = value
		}
		
		public function addTickListener(listener:TickListener):Boolean
		{
			if (!listener) return false;
			
			for (var i:Number = 0; i < _tickListenersList.length; i++ )
			{
				if (_tickListenersList[i] == listener) return false;
			}
			
			this.addEventListener(TICK_EVENT, listener.onTick);
			start();
			
			_tickListenersList.push(listener);
			
			return true;
		}
		
		public function removeTickListener(listener:TickListener):Boolean
		{
			for (var i:Number = 0; i < _tickListenersList.length; i++)
			{
				if (_tickListenersList[i] == listener)
				{
					this.removeEventListener(TICK_EVENT, listener.onTick);
					
					_tickListenersList.splice(i, 1);
					return true;
				}
			}
			
			if (_tickListenersList.length == 0) stop();
			
			return false;
		}
		
		public function notify(info:Object):void
		{
			if (!info) info = null;
			if (!_isChanging) return;
		}
		
		private function timerHandler(e:TimerEvent):void 
		{
			dispatchEvent(new Event(TICK_EVENT));
		}
		
		public function start():void
		{
			if (!_isTicking)
			{
				_timer.start();
				_isTicking = true;
			}
		}
		
		public function stop():void
		{
			if (_isTicking)
			{
				_timer.stop();
				_isTicking = false;
			}
		}
		
		public function reset():void
		{
			stop();
			_timer.reset();
		}
		
	}
}
internal class PrivateConstructorAccess {}