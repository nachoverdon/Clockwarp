package objects;

import flixel.FlxSprite;

class Platform extends FlxSprite {
  static var UP: String = 'UP';
  static var DOWN: String = 'DOWN';
  static var LEFT: String = 'LEFT';
  static var RIGHT: String = 'RIGHT';
  static var VERT: String = 'VERTICAL';
  static var HORI: String = 'HORIZONTAL';
  static var vel: Int = 100;
  static var maxVel: Int = 50;
  var init_x: Float;
  var init_y: Float;
  public var isActivated: Bool = false;
  public var id: Int;
  public var direction: String;
  public var type: String;

  override public function new(x: Float, y: Float, id: Int, direction: String) {
    super(x, y);
    this.id = id;
    this.direction = direction;
    init_x = x;
    init_y = y;
    // immovable = true;
    mass = 2;
    maxVelocity.set(maxVel, maxVel);
    loadGraphic('assets/images/platform.png', true, 64, 32);
    handleType();
    handleRotation();
  }

  override public function update(elapsed: Float) {
    super.update(elapsed);
    handleDirections();
    if (isActivated) changeDirection();
  }

  function handleType() {
    if (direction == UP || direction == DOWN) type = VERT;
    else if (direction == LEFT || direction == RIGHT) type = HORI;
  }
  // Rotates the platform 90 degrees if the platform is the vertical type
  // TODO: and adjusts the hitboxes
  function handleRotation() {
    if (type == VERT) {
      x = init_x;
      angle = 90;
      offset.set(22, -16);
      width = 18;
      height = 64;
    } else if (type == HORI) {
      y = init_y;
      angle = 0;
      offset.set(0, 7);
      width = 64;
      height = 18;
    }
  }

  // Changes platform acceleration and type depending on direction
  function handleDirections() {
    // velocity.x = 0;
    // velocity.y = 0;
    // acceleration.x = 0;
    // acceleration.y = 0;

    if (direction == UP) velocity.y = -vel;
    else if (direction == DOWN) velocity.y = vel;
    else if (direction == LEFT) velocity.x = -vel;
    else if (direction == RIGHT) velocity.x = vel;
  }

  // Changes the direction to its opposite
  function changeDirection(): Void {
    if (direction == UP) direction = DOWN;
    else if (direction == DOWN) direction = UP;
    else if (direction == LEFT) direction = RIGHT;
    else if (direction == RIGHT) direction = LEFT;
  }

}

