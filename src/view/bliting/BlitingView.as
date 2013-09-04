/**
 * BlitingView.
 * Date: 03.09.13
 * Time: 23:11
 * Sergey Sydorenko - sergey.sydorenko@gmail.com
 */
package view.bliting {
	import controller.GameController;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class BlitingView extends Sprite {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var scene:BitmapData;

		private var backGround:BitmapData;
		private var bat:BitmapData;
		private var ball:BitmapData;

		private var gameController:GameController;

		private var score:TextField;
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
		public function BlitingView(controller:GameController) {
			gameController = controller;
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

		private function prepareViewComponents():void {
			var bg:Sprite = new Sprite();
			var gr:Graphics = bg.graphics;
			gr.beginFill(0x00FF36, 1.0);
			gr.drawRect(0, 0, stage.stageWidth, Constants.THICKNESS_OF_LINES);
			gr.drawRect(0, stage.stageHeight - Constants.THICKNESS_OF_LINES, stage.stageWidth, Constants.THICKNESS_OF_LINES);

			const lengthOfNetHole:int = 40;
			const middleOfField:int = (stage.stageWidth - Constants.THICKNESS_OF_LINES) * .5;
			for (var i:int = 0; i * lengthOfNetHole < stage.stageWidth; i += 2 ){
				gr.drawRect(middleOfField, i * lengthOfNetHole + Constants.THICKNESS_OF_LINES, Constants.THICKNESS_OF_LINES, lengthOfNetHole);
			}
			gr.endFill();

			backGround = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0x000000);
			backGround.draw(bg);

			bat = new BitmapData(Constants.THICKNESS_OF_LINES, Constants.LENGTH_OF_BAT, false, 0x00FF36);
			ball = new BitmapData(Constants.THICKNESS_OF_LINES, Constants.THICKNESS_OF_LINES, false, 0x00FF36);
		}
		//--------------------------------------------------------------------------
		//  Handlers 
		//--------------------------------------------------------------------------
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			prepareViewComponents();

			scene = new BitmapData(stage.stageWidth, stage.stageHeight, true, 0x000000);
			addChild(new Bitmap(scene));

			gameController.registerFieldSize(stage.stageWidth, stage.stageHeight);

			score = new TextField();
			score.autoSize = TextFieldAutoSize.CENTER;
			score.multiline = true;
			score.selectable = false;
			score.defaultTextFormat = new TextFormat("Aria", 27, 0x00FF00, true, null, null, null, null, TextFormatAlign.CENTER);
			score.appendText(gameController.getScore);
			score.alpha = .5;
			score.x = (stage.stageWidth - score.width) >> 1;
			score.y = stage.stageHeight - score.height - 20;
			addChild(score);

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			gameController.addEventListener(Event.COMPLETE, onComleteLevel)

			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardAction);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardAction);
		}

		private function onComleteLevel(event:Event):void {
			score.text = gameController.getScore;
			score.x = (stage.stageWidth - score.width) >> 1;
			score.y = stage.stageHeight - score.height - 20;
		}

		private function onKeyboardAction(event:KeyboardEvent):void {
			var acceleration:int = event.type == KeyboardEvent.KEY_UP ? 0 : Constants.BAT_ACCELERATION;
			switch (event.keyCode){
				case 87:
						gameController.changeAccelerationForLeftBat(-acceleration);
					break;
				case 83:
						gameController.changeAccelerationForLeftBat(acceleration);
					break;
				case 38:
						gameController.changeAccelerationForRightBat(-acceleration);
					break;
				case 40:
						gameController.changeAccelerationForRightBat(acceleration);
					break;
			}
		}

		private function onEnterFrame(event:Event):void {
			scene.copyPixels(backGround, backGround.rect, backGround.rect.topLeft);

			scene.lock();

			scene.copyPixels(bat, bat.rect, gameController.getLeftBatPlace);
			scene.copyPixels(bat, bat.rect, gameController.getRightBatPlace);
			scene.copyPixels(ball, ball.rect, gameController.getBallPlace);

			scene.unlock();
		}


	}
}
