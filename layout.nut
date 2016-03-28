class UserConfig {

//-----------------------------------------------------------------
</ label="spinwheel artwork", help="marquee or wheel", options="marquee,wheel", order=12 /> spinwheelArt="wheel";
//-----------------------------------------------------------------
}


fe.load_module("conveyor");
fe.load_module( "fade" );

local my_config = fe.get_config();

fe.layout.width = 1680;
fe.layout.height = 1050;
local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;
print( fe.layout.width + "x" + fe.layout.height+ "\n");



/**
 * Add default styled text.
 *
 * @param  {string} msg
 * @param  {int} x
 * @param  {int} y
 * @param  {int} w
 * @param  {int} h
 * @param  {int} fontsize
 * @return {fe.Text}
 */
function default_text(msg, x, y, w, h, fontsize) {
  local text = fe.add_text(msg, x, y, w, h);
  text.align = Align.Left;
  text.font = "Open Sans";
  text.charsize = fontsize;
  text.style = Style.Bold;

  return text;
}

/**
 * Add black outline text.
 *
 * @param {string} msg
 * @param {int} x
 * @param {int} y
 * @param {int} w
 * @param {int} h
 * @param {int} thickness
 * @param {int} fontsize
 * @return {fe.Text}
 */
function add_outlined_text(msg, x, y, w, h, thickness, fontsize) {
  local minX = x - thickness;
  local maxX = x + thickness;
  local minY = y - thickness;
  local maxY = y + thickness;
  local i = 0;
  local text;

  // Add outline
  for (i; i < maxX-minX; i++) {
    // \
    text = default_text(msg, minX+i, minY+i, w, h, fontsize);
    text.set_rgb(0, 0, 0);

    // /
    text = default_text(msg, minX+i, maxY-i, w, h, fontsize);
    text.set_rgb(0, 0, 0);

    // |
    text = default_text(msg, x, minY+i, w, h, fontsize);
    text.set_rgb(0, 0, 0);

    // -
    text = default_text(msg, minX+i, y, w, h, fontsize);
    text.set_rgb(0, 0, 0);
  }

  // Add text
  text = default_text(msg, x, y, w, h, fontsize);

  return text;
}

class WheelEntry extends ConveyorSlot
{
  x = null;
  y = null;
  w = null;
  a = null;
  h = null;
  r = null;

	constructor(wheel_x, wheel_y, wheel_w, wheel_a, wheel_h, wheel_r)
	{
		base.constructor( ::fe.add_artwork( my_config["spinwheelArt"] ) );
    preserve_aspect_ratio = true;
    video_flags = Vid.ImagesOnly; // added just in case if you have video marquees - like I do :)
    x = wheel_x;
    y = wheel_y;
    w = wheel_w;
    a = wheel_a;
    h = wheel_h;
    r = wheel_r;
	}

	function on_progress(progress, var)
	{
		local p = progress / 0.1;
		local slot = p.tointeger();
		p -= slot;

		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=9 ) slot=9;

		m_obj.x = x[slot] + p * ( x[slot+1] - x[slot] );
		m_obj.y = y[slot] + p * ( y[slot+1] - y[slot] );
		m_obj.width = w[slot] + p * ( w[slot+1] - w[slot] );
		m_obj.height = h[slot] + p * ( h[slot+1] - h[slot] );
		m_obj.rotation = r[slot] + p * ( r[slot+1] - r[slot] );
		m_obj.alpha = a[slot] + p;
	}
};

class Wheel
{
  wheel_x = [ flx*0.87, flx*0.79, flx*0.765, flx*0.745, flx*0.73, flx*0.72, flx*0.67, flx*0.72, flx*0.73, flx*0.745, flx*0.765, flx*0.79, ];
  wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
  wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.28, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
  wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
  wheel_h = [  flw*0.07,  flw*0.07,  flw*0.07,  flw*0.08,  flw*0.08,  flw*0.08, flw*0.11,  flw*0.07,  flw*0.07,  flw*0.07,  flw*0.07,  flw*0.07, ];
//  wheel_r = [  31,  26,  21,  16,  11,   6,   0, -11, -16, -21, -26, -31, ];
  wheel_r = [  30,  25,  20,  15,  10,   5,   0, -10, -15, -20, -25, -30, ];
  /*wheel_r = [ 0, 0,0,0,0,0,0,0,0,0,0,0, 30, 25, 20, 15, 10, 5, 0, -10, -15, -20, -25, -30, ];*/
  num_arts = 10;  // number of elements in wheel - depending on screen aspect ratio
  wheel_entries = [];

  constructor(frontend)
  {

    local i = 0;
    for (i; i < num_arts/2; i++) {
    	wheel_entries.push( WheelEntry(wheel_x, wheel_y, wheel_w, wheel_a, wheel_h, wheel_r) );
    }

    local remaining = num_arts - wheel_entries.len();

    // we do it this way so that the last wheelentry created is the middle one showing the current
    // selection (putting it at the top of the draw order)

    for (i = 0; i < remaining; i++) {
    	wheel_entries.insert(num_arts/2, WheelEntry(wheel_x, wheel_y, wheel_w, wheel_a, wheel_h, wheel_r) );
    }

    local conveyor = Conveyor();
    conveyor.set_slots(wheel_entries);
    conveyor.transition_ms = 50;
    try {
      conveyor.transition_ms = 80;
    } catch (e) {}
  }
}

/**
 * Handle processing and display of game meta info
 */
class GameInfo
{
  fe = null;
  name = null;
  year = null;
  manufacturer = null;
  outline = 5;
  color = [255, 255, 255];

  constructor(frontend)
  {
    fe = frontend;

    this.displayVideo();
    this.displayFlyer();
    this.displayName();
    this.displayMeta();
  }

  function getName()
  {
    name = fe.game_info(Info.Name);
    return name.len() ? "[Title]" : "[unknown]";
  }

  function getMeta()
  {
    year = fe.game_info(Info.Year);
    manufacturer = fe.game_info(Info.Manufacturer);
    if (year.len() && manufacturer.len()) {
      return "[Year], [Manufacturer]";
    } else if (year.len()) {
      return "[Year]";
    } else if (manufacturer.len()) {
      return "[Manufacturer]";
    }
    return "Witchert, 2015";
  }

  function displayName()
  {
    local x = 50;
    local y = fe.layout.height - 100;
    local w = fe.layout.width - x;
    local h = 0;
    local text = add_outlined_text(getName(), x, y, w, h, outline, 42);
    text.set_rgb(color[0], color[1], color[2]);
  }

  function displayMeta()
  {
    local x = 60;
    local y = fe.layout.height - 146;
    local w = fe.layout.width - x;
    local h = 0;
    local text = add_outlined_text(getMeta(), x, y, w, h, outline, 24);
    text.set_rgb(color[0], color[1], color[2]);
  }

  function displayVideo()
  {
    local scanlineShader = fe.add_shader( Shader.VertexAndFragment, "crt.vert", "crt.frag" );
    scanlineShader.set_param( "rubyInputSize", 640, 480 );
    scanlineShader.set_param( "rubyOutputSize", fe.layout.width, fe.layout.height );
    scanlineShader.set_param( "rubyTextureSize", 640, 480 );
    scanlineShader.set_texture_param( "rubyTexture" );

    local video = fe.add_artwork("video", 0, 0, fe.layout.width, 0);
    video.video_flags = Vid.NoAudio;
    video.preserve_aspect_ratio = true;
    video.shader = scanlineShader

    local masking = fe.add_image( "background_mask.png", 0, 0, fe.layout.width, fe.layout.height);
    masking.preserve_aspect_ratio = false;
    masking.alpha = 150;
  }

  function displayFlyer()
  {
    local x = 200;
    local y = 150;
    local w = 0;//fe.layout.width / 2;//fe.layout.width - x;
    local h = fe.layout.height - 400;
    local flyer = fe.add_artwork("flyer",x, y, w, h);
    flyer.rotation = -5;
    flyer.preserve_aspect_ratio = true;
  }
}

class UI
{
  constructor (frontend)
  {
    this.fe = frontend;

    displayButtons();
    displayDisplay();
  }

  function displayButtons()
  {
    fe.add_image("red.png", 60, fe.layout.height-52, 64, 34);
    add_outlined_text("Select", 124, fe.layout.height-37, 100, 0, 5, 24);

    fe.add_image("yellow.png", 256, fe.layout.height-52, 64, 34);
    add_outlined_text("Next Favourite", 320, fe.layout.height-37, 300, 0, 5, 24);

    fe.add_image("green.png", 550, fe.layout.height-52, 64, 34);
    add_outlined_text("Add/Remove Favourite", 614, fe.layout.height-37, 300, 0, 5, 24);

    fe.add_image("blue.png", 940, fe.layout.height-52, 64, 34);
    add_outlined_text("Next Letter", 1004, fe.layout.height-37, 300, 0, 5, 24);
  }

  function displayDisplay()
  {
    add_outlined_text("[System] - [ListEntry]/[ListSize]", 1450, fe.layout.height-37, 300, 0, 5, 24);
  }
}

local gameInfo = GameInfo(fe);
local wheel = Wheel(fe);
local ui = UI(fe);
