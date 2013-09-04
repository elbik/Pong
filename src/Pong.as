/**
 * Pong.
 * Date: 03.09.13
 * Time: 22:00
 * Sergey Sydorenko - sergey.sydorenko@gmail.com
 */
package {
	import controller.GameController;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	import view.bliting.BlitingView;

	[SWF (width="640", height="480", frameRate="60", backgroundColor="#000000")]
	public class Pong extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function Pong() {

			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		private function initializeGame():void {
			var controller:GameController = new GameController();
			var view:BlitingView = new BlitingView(controller);
			addChild(view);
		}

		//--------------------------------------------------------------------------
		//  Handlers 
		//--------------------------------------------------------------------------
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			var gr:Graphics = this.graphics;
			gr.beginFill(0x000000, 1.0);
			gr.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			gr.endFill();

			var options:TextField = new TextField();
			options.autoSize = TextFieldAutoSize.CENTER;
			options.multiline = true;
			options.selectable = false;
			options.appendText("Press \"S\" for start");
			options.setTextFormat(new TextFormat("Aria", 27, 0x00FF00, true, null, null, null, null, TextFormatAlign.CENTER));
			options.x = (stage.stageWidth - options.width) >> 1;
			options.y = (stage.stageHeight - options.height) >> 1;
			addChild(options);

			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
		}

		private function onKeyboardEvent(event:KeyboardEvent):void {
			if(event.keyCode){
				stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardEvent);
				removeChildren();
				initializeGame();
			}
		}



	}
}
