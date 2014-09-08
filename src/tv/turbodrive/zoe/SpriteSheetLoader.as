package tv.turbodrive.zoe
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	
	public class SpriteSheetLoader extends EventDispatcher
	{

		private var _imageFile:String;
		private var _jsonFile:String;
		
		private var _data:String;
		private var _image:Bitmap;
		
		public function SpriteSheetLoader(imageFile:String, jsonFile:String)
		{
			_imageFile = imageFile;
			_jsonFile = jsonFile
		}
		
		public function load():void
		{
			var request:URLRequest = new URLRequest(_jsonFile);
			request.requestHeaders = [new URLRequestHeader("Content-Type", "application/json")];			
			request.method = URLRequestMethod.GET;
			
			var loader:URLLoader=new URLLoader();
			loader.addEventListener(Event.COMPLETE, jsonLoaded);
			/*loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, notAllowed);
			loader.addEventListener(IOErrorEvent.IO_ERROR, notFound);*/
			loader.load(request);
		}
		
		public function get jsonData():String
		{
			return  _data
		}
		
		public function get bitmap():Bitmap
		{
			return  _image
		}
		
		private function jsonLoaded(event:Event):void
		{
			URLLoader(event.target).removeEventListener(Event.COMPLETE,jsonLoaded);
			_data = URLLoader(event.target).data
			
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaded)
			loader.load(new URLRequest(_imageFile))
		}		
		
		private function imageLoaded(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE,imageLoaded);
			_image = LoaderInfo(event.target).content as Bitmap
				
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}	
}