package tv.turbodrive.puremvc.proxy.data
{
	import flash.display.BlendMode;
	
	import tv.turbodrive.utils.Path;

	public class Asset
	{
		private var _loaded:Boolean = false;
		private var _useJson:Boolean = true;
		private var _file:String;
		private var _jsonFile:String;
		private var _type:String;
		private var _id:String;
		private var _required:Boolean;
		private var _mainAsset:Boolean;
		private var _priority:int;
		public var isLoading:Boolean = false;			
		public var blendMode:String = BlendMode.NORMAL
		public var parsed:Boolean = false
			
		public function Asset(id:String, file:String, type:String, priority:int, mainAsset:Boolean = false, required:Boolean = false, jsonFile:String = null)
		{	
			_id = id;
			_file = file;
			if(jsonFile && jsonFile.length > 1) _jsonFile = jsonFile
			_type = type
			_required = required
			_priority = priority
			_mainAsset = mainAsset
		}
		
		public function get type():String
		{
			return _type
		}
		
		public function get id():String
		{
			return _id
		}
		
		public function get file():String
		{
			return Path.ASSETS_DIR + _type +"/" +_file
		}
		
		public function get jsonFile():String
		{
			if(!_jsonFile) return null
				
			return Path.ASSETS_DIR + _type +"/" + _jsonFile
		}
		
		public function get isLoaded():Boolean
		{
			return _loaded
		}
		
		public function set isLoaded(value:Boolean):void
		{
			if(value) _loaded = value
		}
		
		public function get isRequired():Boolean
		{
			return _required
		}
		
		public function get isMainAsset():Boolean
		{
			return _mainAsset
		}
		
		public function get priority():int
		{
			return _priority
		}
		
		public function toString():String
		{
			return ("Asset - " + _id + " - fileName: " + _file +" - " + _type + " | loaded : " + _loaded);
		}
	}
}