package com.verticalcue.api.snipt 
{
	import com.verticalcue.errors.InstanceError;
	import com.verticalcue.errors.InvalidParameterError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/*
	 * Snipt AS3 Library is designed to be a very simple API interface library between snipt.net and AS3.
	 * @version 1.0
	 * @author John Vrbanac
	 * 
	 * Snipt-AS3 is free software: you can redistribute it and/or modify
	 * it under the terms of the GNU General Public License as published by
	 * the Free Software Foundation, either version 3 of the License, or
	 * at your option) any later version.
	 *
	 * Snipt-AS3 is distributed in the hope that it will be useful,
	 * but WITHOUT ANY WARRANTY; without even the implied warranty of
	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	 * GNU General Public License for more details.
	 *
	 * You should have received a copy of the GNU General Public License
	 * along with Snipt-AS3. If not, see <http://www.gnu.org/licenses/>.
	 *
	 */
	public class SniptNetLib 
	{
		private static const SNIPTNET_BASE_URL:String = "https://snipt.net/api/";
		private static var _username:String = "";
		private static var _apiKey:String = "";
		private static var _instance:SniptNetLib;
		
		public function SniptNetLib() 
		{
			if (_instance) {
				throw new InstanceError("This class has already been instantiated. Use the instance property.");
			}
		}
		
		public static function setLogin (username:String, apiKey:String):void
		{
			if (username.length <= 0 || apiKey.length <= 0) {
				throw new InvalidParameterError();
			}
				
			_username = username;
			_apiKey = apiKey;
		}
		
		public static function get instance():SniptNetLib 
		{
			if (!_instance) {
				_instance = new SniptNetLib();
			}
			
			return _instance;
		}
		
		/**
		 * Basic query function that passing on a query to Snipt.net
		 * @param	query Contains a url parameter string i.e. q=searchString&order_by=created
		 * @param	callback The function(e:Event) that handles the data returned
		 * @param	offset The starting index of the query
		 * @param	limit The max return count for the query
		 * @param	privateSnippets Forces the query to look into a user's private snippets
		 */
		public static function queryApi(query:String, callback:Function, offset:int = 0, limit:int = 5, privateSnippets:Boolean = false):void
		{
			// Catch the assumption that we will have a proper login
			if (privateSnippets && (_username.length <= 0 || _apiKey.length <= 0)) {
				throw new InvalidParameterError("You are attempting to make a query for private snippets without setting a login");
			}
			
			var remainingURL:String = (privateSnippets ? "private" : "public") + "/snipt/";
			var httpLoader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			var requestParameters:URLVariables = new URLVariables();
			
			requestParameters.decode(query);
			requestParameters.format = "xml";
			requestParameters.offset = offset;
			requestParameters.limit = limit;
			
			// Adding login if needed
			if (privateSnippets) {
				requestParameters.username = _username;
				requestParameters.api_key = _apiKey;
			}
			
			request.url = SNIPTNET_BASE_URL + remainingURL;
			request.method = URLRequestMethod.GET;
			request.data = requestParameters;
			
			httpLoader.addEventListener(Event.COMPLETE, callback);
			httpLoader.addEventListener(IOErrorEvent.IO_ERROR, loaderIOError);
			
			httpLoader.load(request);			
		}
		
		private static function loaderIOError(e:IOErrorEvent):void 
		{
			trace("Error loading url: " + e.text);
		}
	}

}