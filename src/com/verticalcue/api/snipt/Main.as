package com.verticalcue.api.snipt
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author John Vrbanac
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//SniptNetLib.setLogin("api_test_user", "a0eb5dfb1e8c26366b9b5cfea3f7dc20543bf1fb");
			SniptNetLib.queryApi("q=as3", result, 0, 5, false);
		}
		
		private function result(e:Event):void 
		{
			var xml:XML = new XML(e.currentTarget.data);
			trace(xml.toXMLString());
			trace("got here");
		}
		
	}
	
}