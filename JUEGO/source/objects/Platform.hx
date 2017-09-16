package objects;

import flixel.FlxSprite;

class Platform extends FlxSprite {
  static var UP: String = 'UP';
  static var DOWN: String = 'DOWN';
  static var LEFT: String = 'LEFT';
  static var RIGHT: String = 'RIGHT';
  static var VERT: String = 'VERTICAL';
  static var HORI: String = 'HORIZONTAL';
  static var accel: Int = 100;
  static var maxVel: Int = 50;
  public var id: Int;
  public var direction: String;
  public var type: String;

  override public function new(x: Float, y: Float, id: Int, direction: String) {
    super(x, y);
    this.id = id;
    this.direction = direction;
    // immovable = true;
    maxVelocity.set(maxVel, maxVel);
    handleType();
    handleRotation();
    loadGraphic('assets/images/platform.png', true, 64, 32);
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    handleDirections();
  }

  function handleType() {
    if (direction == UP && direction == DOWN) type = VERT;
    else if (direction == LEFT && direction == RIGHT) type = HORI;
  }
  // Rotates the platform 90 degrees if the platform is the vertical type
  // TODO: and adjusts the hitboxes
  function handleRotation() {
    if (type == VERT) angle += 90;
  }

  // Changes platform acceleration and type depending on direction
  function handleDirections() {
    acceleration.x = 0;
    acceleration.y = 0;

    if (direction == UP) acceleration.y = -accel;
    else if (direction == DOWN) acceleration.y = accel;
    else if (direction == LEFT) acceleration.x = -accel;
    else if (direction == RIGHT) acceleration.x = accel;
  }

  // Changes the direction to its opposite
  public function changeDirection(): Void {
    if (direction == UP) direction = DOWN;
    else if (direction == DOWN) direction = UP;
    else if (direction == LEFT) direction = RIGHT;
    else if (direction == RIGHT) direction = LEFT;
  }

}

