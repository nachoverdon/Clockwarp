package states;

class Level1 extends GameState {
  override public function create(): Void {
    LEVEL_NAME = 'level1';
    super.create();
  }

  // override public function update(elapsed: Float): Void {
  //   super.update(elapsed);
  // }
}