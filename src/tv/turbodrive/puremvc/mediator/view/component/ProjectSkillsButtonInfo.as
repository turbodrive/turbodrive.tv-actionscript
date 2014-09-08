package tv.turbodrive.puremvc.mediator.view.component
{
	import tv.turbodrive.utils.FlashTextEngine;

	public class ProjectSkillsButtonInfo
	{
		
		private var _id:int;
		private var _title:String;
		private var _content:String;
		public var  type:String
		
		public function ProjectSkillsButtonInfo(id:int,title:String, content:String = null )
		{
			_id = id
			_title = title
			_content = content
		}
		
		public function get labelAlign():String
		{
			if(_id > 4) return FlashTextEngine.RIGHT_ALIGN
			return FlashTextEngine.LEFT_ALIGN
		}
		
		public function get id():int
		{
			return _id
		}

		public function get title():String
		{
			return _title
		}
		
		public function get content():String
		{
			return _content
		}
			
	}
}