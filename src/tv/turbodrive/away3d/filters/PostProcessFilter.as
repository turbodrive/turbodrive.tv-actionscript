package tv.turbodrive.away3d.filters
{
	import away3d.filters.Filter3DBase;
	import tv.turbodrive.away3d.filters.tasks.Filter3DPostProcessTask;
	
	public class PostProcessFilter extends Filter3DBase
	{
		private var _ppTask : Filter3DPostProcessTask;
		
		public function PostProcessFilter()
		{
			super();
			_ppTask = new Filter3DPostProcessTask();
			addTask(_ppTask)      
		}
	}
}