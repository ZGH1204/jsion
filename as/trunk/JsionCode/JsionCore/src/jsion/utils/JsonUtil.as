/*
Adobe Systems Incorporated(r) Source Code License Agreement
Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
	
Please read this Source Code License Agreement carefully before using
the source code.
	
Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
no-charge, royalty-free, irrevocable copyright license, to reproduce,
prepare derivative works of, publicly display, publicly perform, and
distribute this source code and such derivative works in source or
object code form without any attribution requirements.
	
The name "Adobe Systems Incorporated" must not be used to endorse or promote products
derived from the source code without prior written permission.
	
You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
against any loss, damage, claims or lawsuits, including attorney's
fees that arise or result from your use or distribution of the source
code.
	
THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package jsion.utils {
	import flash.utils.describeType;
	
	import jsion.core.serialize.json.*;
	
	/**
	 * Json数据格式化工具
	 *
	 * Example usage:<br />
	 * <code>
	 * 		// create a JSON string from an internal object<br />
	 * 		JSON.encode( myObject );<br />
	 *		<br />
	 *		// read a JSON string into an internal object<br />
	 *		var myObject:Object = JSON.decode( jsonString );<br />
	 *	</code><br />
	 * 
	 * @author Jsion
	 * @langversion 3.0
	 * @playerversion Flash 9
	 * @playerversion AIR 1.1
	 * @productversion JUtils 1
	 */
	public final class JsonUtil {
	
	
		/**
		 * Encodes a object into a JSON string.
		 *
		 * @param o The object to create a JSON string for
		 * @return the JSON string representing o
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function encode( o:Object ):String {
			
			var encoder:JSONEncoder = new JSONEncoder( o );
			return encoder.getString();
		
		}
		
		/**
		 * Decodes a JSON string into a native object.
		 * 
		 * @param s The JSON string representing the object
		 * @return A native object as specified by s
		 * @throw JSONParseError
		 * @langversion ActionScript 3.0
		 * @playerversion Flash 9.0
		 * @tiptext
		 */
		public static function decode( s:String):* {
			
			var decoder:JSONDecoder = new JSONDecoder( s );
			return decoder.getValue();
		}
		/**
		 * Decodes a JSON string into a spefic class instance.
		 * 
		 * @param s The Json string representing the object.
		 * @param type The instance type.
		 */
		public static function decodeType(s:String,type:Class):*
		{
			var decoder:JSONDecoder = new JSONDecoder( s );
			
			var value:Object = decoder.getValue();
			var result:Object = new type();
			var classInfo:XML = describeType(result);
			for each ( var v:XML in classInfo..*.( name() == "variable" || name() == "accessor" ) ) 
			{
				result[v.@name] = value[v.@name];
			}
			return result;
		}
	
	}

}