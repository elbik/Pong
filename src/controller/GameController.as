/**
 * GameController.
 * Date: 03.09.13
 * Time: 23:08
 * Sergey Sydorenko - sergey.sydorenko@gmail.com
 */
package controller {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	import model.GameModel;

	public class GameController extends EventDispatcher {
		//--------------------------------------------------------------------------
		//  Constants
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Variables
		//--------------------------------------------------------------------------
		private var pongModel:GameModel;

		private var width:int;
		private var height:int;

		//--------------------------------------------------------------------------
		//  Public properties
		//--------------------------------------------------------------------------
		/**
		 * Position of the left bat
		 */
		public function get getLeftBatPlace():Point {
			if(pongModel.leftBatAcceleration){
				var newPosition:int = pongModel.leftBatPosition + pongModel.leftBatAcceleration;
				if(newPosition >= Constants.THICKNESS_OF_LINES && newPosition <= height - Constants.THICKNESS_OF_LINES)
					pongModel.leftBatPosition = newPosition;
			}
			return new Point(0, pongModel.leftBatPosition - Constants.LENGTH_OF_BAT *.5);
		}

		/**
		 * Position of the right bat
		 */
		public function get getRightBatPlace():Point {
			if(pongModel.rightBatAcceleration){
				var newPosition:int = pongModel.rightBatPosition + pongModel.rightBatAcceleration;
				if(newPosition >= Constants.THICKNESS_OF_LINES && newPosition <= height - Constants.THICKNESS_OF_LINES)
					pongModel.rightBatPosition = newPosition;
			}
			return new Point(width - Constants.THICKNESS_OF_LINES, pongModel.rightBatPosition - Constants.LENGTH_OF_BAT *.5);
		}

		/**
		 * Position of the ball
		 */
		public function get getBallPlace():Point {
			var ballPlace:Point = pongModel.ballPosition;
			const halfOfBatLength:int = Constants.LENGTH_OF_BAT >> 1;
			const halfOfBall:int = Constants.THICKNESS_OF_LINES >> 1;
			var placeOfColition:int;
			var newBallPlace:Point = new Point(ballPlace.x + pongModel.ballAcceleration.x , ballPlace.y + pongModel.ballAcceleration.y);

			if(newBallPlace.y <= Constants.THICKNESS_OF_LINES || newBallPlace.y >= height - Constants.THICKNESS_OF_LINES * 2){
				pongModel.ballAcceleration.y *= -1;
			}
			if(newBallPlace.x < Constants.THICKNESS_OF_LINES){
				placeOfColition = newBallPlace.y - pongModel.leftBatPosition + halfOfBall;
				if(Math.abs(placeOfColition) <= halfOfBatLength){
					pongModel.ballAcceleration.x *= -1;
					pongModel.ballAcceleration.y += placeOfColition / halfOfBatLength * 2;
				} else{
					pongModel.rightPlayerScore++;
					resetLevel(-1);
				}
			}

			if(newBallPlace.x > width - Constants.THICKNESS_OF_LINES * 2){
				placeOfColition = newBallPlace.y - pongModel.rightBatPosition + halfOfBall;
				if(Math.abs(placeOfColition) <= halfOfBatLength){
					pongModel.ballAcceleration.x *= -1;
					pongModel.ballAcceleration.y += placeOfColition / halfOfBatLength * 2;
				}else{
					pongModel.leftPlayerScore++;
					resetLevel(1);
				}
			}
			ballPlace.x = newBallPlace.x;
			ballPlace.y = newBallPlace.y;
			return ballPlace;
		}

		/**
		 * score of the game
		 */
		public function get getScore():String {
			return pongModel.leftPlayerScore + "        " + pongModel.rightPlayerScore;
		}
		//--------------------------------------------------------------------------
		//  Protected properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private properties
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Constructor
		//--------------------------------------------------------------------------
		public function GameController() {
			pongModel = new GameModel();
		}

		//--------------------------------------------------------------------------
		//  Public methods
		//--------------------------------------------------------------------------
		/**
		 * initialize game size in controller
		 * @param stageWidth
		 * @param stageHeight
		 */
		public function registerFieldSize(stageWidth:int, stageHeight:int):void {
			width = stageWidth;
			height = stageHeight;

			pongModel.leftBatPosition = height >> 1;
			pongModel.rightBatPosition = height >> 1;

			resetLevel(Math.random() <.5 ? -1 : 1);
		}

		/**
		 * change acceleration move for left bat
		 * @param value - acceleration
		 */
		public function changeAccelerationForLeftBat(value:int):void {
			pongModel.leftBatAcceleration = value;
		}

		/**
		 * change acceleration move for right bat
		 * @param value - acceleration
		 */
		public function changeAccelerationForRightBat(value:int):void {
			pongModel.rightBatAcceleration = value;
		}
		//--------------------------------------------------------------------------
		//  Protected methods
		//--------------------------------------------------------------------------

		//--------------------------------------------------------------------------
		//  Private methods
		//--------------------------------------------------------------------------
		/**
		 * reset level
		 * @param direction - direction of the ball flight
		 */
		private function resetLevel(direction:int = 1):void {
			pongModel.ballPosition = new Point(width >> 1, height >> 1);
			pongModel.ballAcceleration = new Point(Constants.BALL_ACCELERATION * direction, 0);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		//--------------------------------------------------------------------------
		//  Handlers
		//--------------------------------------------------------------------------


	}
}
