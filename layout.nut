class UserConfig {

</ label="NEVATO theme", help=" ", options=" ", order=1 /> divider1="";
</ label="- - -", help=" ", options=" ", order=1 /> divider1="";
//-----------------------------------------------------------------
</ label="mute videos snaps sound", help="yes = sound disabled, no = sound enabled", options="yes,no", order=2 /> mute_videoSnaps="no";

</ label="- - -", help=" ", options=" ", order=3 /> divider2="";
//-----------------------------------------------------------------
</ label="cab screen", help="video = video snap, screenshot = game screenshot", options="video, screenshot", order=4 /> cabScreenType="video";
</ label="scanlines on screen", help="show scanlines effect on cab screen.", options="light,medium,dark,off", order=5 /> enable_scanlines="light";

</ label="- - -", help=" ", options=" ", order=6 /> divider3="";
//-----------------------------------------------------------------
</ label="marquee artwork", help="marquee type, replace ''my-own-marquee.jpg'' file with your own", options="marquee,emulator-name,my-own", order=7 /> marquee_type="marquee";

</ label="- - -", help=" ", options=" ", order=9 /> divider4="";
//-----------------------------------------------------------------
</ label="LCD right side", help="what's on right side of LCD", options="filter, emulator, display-name, rom-filename, off,", order=10 /> lcdRight="filter";

</ label="- - -", help=" ", options=" ", order=11 /> divider5="";
//-----------------------------------------------------------------
</ label="spinwheel artwork", help="marquee or wheel", options="marquee,wheel", order=12 /> spinwheelArt="wheel";
</ label="speenwheel transition time", help="Time in milliseconds for wheel spin.", order=13 /> transition_ms="80";

</ label="- - -", help=" ", options=" ", order=14 /> divider6="";
//-----------------------------------------------------------------
</ label="background art", help="Display the flyer/fanart/snap(screenshot)/video in background.", options="flyer,fanart,snap,video,none", order=15 /> enable_bg_art="fanart";
</ label="background ststic image", help="background image if there is no background art", options="blue,black,none", order=16 /> enable_static_bkg="black";
</ label="background mask", help="make background medium or dark", options="dark,medium", order=17 /> enable_mask="dark";

</ label="- - -", help=" ", options=" ", order=18 /> divider7="";
//-----------------------------------------------------------------
}


fe.load_module("conveyor");
fe.load_module( "fade" );

local my_config = fe.get_config();

local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;

//coordinates table for different screen aspects -------------------------- START
local settings = {
   "default": {
      aspectDepend = {
        snap_skewX = 42.0,
        snap_skewY = -8.0,

        snap_pinchX = 0,
        snap_pinchY = 29.0,
        snap_rotation = 0.9,

        marquee_skewX = 17,
        marquee_skewY = 0,
        marquee_pinchX = -2,
        marquee_pinchY = 7,
        marquee_rotation = 6.2,

        wheelNumElements = 10 }
   },
   "16x10": {
      aspectDepend = {
        res_x = 1920,
        res_y = 1200,

        maskFactor = 1.9,

        snap_skewX = 62.5,
        snap_skewY = -12.9,
        snap_pinchX = 0,
        snap_pinchY = 40.0,
        snap_rotation = 1.0,

        wheelNumElements = 10 }
   },
    "16x9": {
      aspectDepend = {
        res_x = 2133,
        res_y = 1200,

        maskFactor = 1.9,

        snap_skewX = 62.5,
        snap_skewY = -12.9,
        snap_pinchX = 0,
        snap_pinchY = 40.0,
        snap_rotation = 1.0,

        wheelNumElements = 8 }
   },
   "4x3": {
      aspectDepend = {
        res_x = 1600,
        res_y = 1200,

        maskFactor = 1.6,

        snap_skewX = 62.5,
        snap_skewY = -12.9,
        snap_pinchX = 0,
        snap_pinchY = 40.0,
        snap_rotation = 1.0,

        wheelNumElements = 10 }
   }
   "5x4": {
      aspectDepend = {
        res_x = 1500,
        res_y = 1200,

        maskFactor = 1.6,

        snap_skewX = 62.5,
        snap_skewY = -12.9,
        snap_pinchX = 0,
        snap_pinchY = 40.0,
        snap_rotation = 1.0,

        wheelNumElements = 10 }
   }
}




local aspect = fe.layout.width / fe.layout.height.tofloat();
print (aspect);
local aspect_name = "";
switch( aspect.tostring() )
{
    case "1.77865":  //for 1366x768 screen
    case "1.77778":  //for any other 16x9 resolution
        aspect_name = "16x9";
        break;
    case "1.6":
        aspect_name = "16x10";
        break;
    case "1.33333":
        aspect_name = "4x3";
        break;
    case "1.25":
        aspect_name = "5x4";
        break;
    case "0.75":
        aspect_name = "3x4";
        break;
}


function Setting( id, name )
{
    if ( aspect_name in settings && id in settings[aspect_name] && name in settings[aspect_name][id] )
  {
    ::print("\tusing settings[" + aspect_name + "][" + id + "][" + name + "] : " + settings[aspect_name][id][name] + "\n" );
    return settings[aspect_name][id][name];
  } else if ( aspect_name in settings == false )
  {
    ::print("\tsettings[" + aspect_name + "] does not exist\n");
  } else if ( name in settings[aspect_name][id] == false )
  {
    ::print("\tsettings[" + aspect_name + "][" + id + "][" + name + "] does not exist\n");
  }
  ::print("\t\tusing default value: " + settings["default"][id][name] + "\n" );
  return settings["default"][id][name];
}




fe.layout.width = Setting("aspectDepend", "res_x");
fe.layout.height = Setting("aspectDepend", "res_y");

local flx = fe.layout.width;
local fly = fe.layout.height;
local flw = fe.layout.width;
local flh = fe.layout.height;

local mask_factor = Setting("aspectDepend", "maskFactor");
//coordinates table for different screen aspects -------------------------- END


// mute audio variable - definable via user config ------------------------ START
if ( my_config["mute_videoSnaps"] == "yes") {
  ::videoSound <- Vid.NoAudio;
}
if ( my_config["mute_videoSnaps"] == "no") {
  ::videoSound <- Vid.Default;
}
// mute audio variable - definable via user config ------------------------ END


// default background image (if background art is not enabled) ------------- START
local bg
switch (my_config["enable_static_bkg"]) {
  case "blue":
    bg = fe.add_image( "background_blue.png", 0, 0, flw, flh );
    break;
  case "black":
    bg = fe.add_image( "background_black.png", 0, 0, flw, flh );
    break;
  default:
    bg = fe.add_image( "", 0, 0, flw, flh );
}
// default background image (if background art is not enabled) ------------- END


// background art --------------------------------------------------------- START
local bgart;
local mask;
switch (my_config["enable_bg_art"]) {
  case "flyer":
    bgart = fe.add_artwork( "flyer", flw*0.2, flw*0, flw*0.6, 0);
    bgart.preserve_aspect_ratio = true;
    mask = fe.add_image( "mask_edges.png", 0 , 0, mask_factor*flh, flh );  //gradient to mask left and right edge of the flyer 1.6 for 4:3 and 16:10  1.9 for 16:9
    mask.preserve_aspect_ratio = false;
    break;
  case "fanart":
    bgart = FadeArt( "fanart", 0, 0, 0, flh);
    bgart.preserve_aspect_ratio = true;
    mask = fe.add_image( "mask_edges.png", 0 , 0, mask_factor*flh, flh );  //gradient to mask left and right edge of the flyer
    mask.preserve_aspect_ratio = false;
    break;
  case "snap":
    bgart = fe.add_artwork( "snap", flx-flh*1.34, 0, flh*1.34, 0);
    bgart.preserve_aspect_ratio = true;
    bgart.video_flags=Vid.ImagesOnly;
    break;
  case "video":
    bgart = fe.add_artwork( "snap", flx-flh*1.34, 0, flh*1.34, 0);
    bgart.preserve_aspect_ratio = true;
    bgart.video_flags = videoSound;
    break;
}
// background art --------------------------------------------------------- END


//masking background (adding scanlines and vignette) -------------------- START
/*
if ( my_config["enable_mask"] == "none" )
{
local masking = fe.add_image( "", 0, 0, flw, 0 );
}


if ( my_config["enable_mask"] == "medium" )
{
local masking = fe.add_image( "background_mask.png", 0, 0, flx, fly );
masking.preserve_aspect_ratio = false;
masking.alpha = 150;           // here you can change mask opacity light=100, medium=150, dark (default)=255
local maskingMedium = fe.add_image( "background_mask_medium.png", 0, 0, flx, fly );
maskingMedium.preserve_aspect_ratio = false;
}


if ( my_config["enable_mask"] == "dark" )
{
local masking = fe.add_image( "background_mask.png", 0, 0, flx,fly);   //for 4:3 fix 1.6*fly
masking.preserve_aspect_ratio = false;
masking.alpha = 255;           // here you can change mask opacity light=100, medium=150, dark (default)=255
}*/

//masking background (adding scanlines and vignette) -------------------- END


//static tv effect on cab screen snap change (of if no snap at all) ------------- START

/*local tvStatic = fe.add_image( "static.jpg", 0, 0, flw, flh);//fe.layout.height*0.0984, fe.layout.height*0.24, fe.layout.height*0.405, fe.layout.height*0.3536);
tvStatic.preserve_aspect_ratio = true;*/
/*tvStatic.skew_x = Setting("aspectDepend", "snap_skewX");
tvStatic.skew_y = Setting("aspectDepend", "snap_skewY");
tvStatic.pinch_x = Setting("aspectDepend", "snap_pinchX");
tvStatic.pinch_y = Setting("aspectDepend", "snap_pinchY");
tvStatic.rotation = Setting("aspectDepend", "snap_rotation");*/


//snap (video or screenshot) on cab screen ------------- START

local cabScreen = fe.add_artwork ("snap", fe.layout.height*0.0984, fe.layout.height*0.24, fe.layout.height*0.405, fe.layout.height*0.3536);
cabScreen.skew_x = Setting("aspectDepend", "snap_skewX");
cabScreen.skew_y = Setting("aspectDepend", "snap_skewY");
cabScreen.pinch_x = Setting("aspectDepend", "snap_pinchX");
cabScreen.pinch_y = Setting("aspectDepend", "snap_pinchY");
cabScreen.rotation = Setting("aspectDepend", "snap_rotation");
cabScreen.trigger = Transition.EndNavigation;
cabScreen.preserve_aspect_ratio = false;

cabScreen.video_flags = videoSound;

if ( my_config["cabScreenType"] == "screenshot" ) {
  cabScreen.video_flags=Vid.ImagesOnly;
}





//scanlines over cab screen --------------------------- START

/*if ( my_config["enable_scanlines"] == "light" )
{
local scanlines = fe.add_image( "scanlines.png", fe.layout.height*0.0984, fe.layout.height*0.24, fe.layout.height*0.405, fe.layout.height*0.3536 );
scanlines.skew_x = Setting("aspectDepend", "snap_skewX");
scanlines.skew_y = Setting("aspectDepend", "snap_skewY");
scanlines.pinch_x = Setting("aspectDepend", "snap_pinchX");
scanlines.pinch_y = Setting("aspectDepend", "snap_pinchY");
scanlines.rotation = Setting("aspectDepend", "snap_rotation");
scanlines.preserve_aspect_ratio = false;
scanlines.alpha = 50;
}

if ( my_config["enable_scanlines"] == "medium" )
{
local scanlines = fe.add_image( "scanlines.png", fe.layout.height*0.0984, fe.layout.height*0.24, fe.layout.height*0.405, fe.layout.height*0.3536 );
scanlines.skew_x = Setting("aspectDepend", "snap_skewX");
scanlines.skew_y = Setting("aspectDepend", "snap_skewY");
scanlines.pinch_x = Setting("aspectDepend", "snap_pinchX");
scanlines.pinch_y = Setting("aspectDepend", "snap_pinchY");
scanlines.rotation = Setting("aspectDepend", "snap_rotation");
scanlines.preserve_aspect_ratio = false;
scanlines.alpha = 150;
}

if ( my_config["enable_scanlines"] == "dark" )
{
local scanlines = fe.add_image( "scanlines.png", fe.layout.height*0.0984, fe.layout.height*0.24, fe.layout.height*0.405, fe.layout.height*0.3536 );
scanlines.skew_x = Setting("aspectDepend", "snap_skewX");
scanlines.skew_y = Setting("aspectDepend", "snap_skewY");
scanlines.pinch_x = Setting("aspectDepend", "snap_pinchX");
scanlines.pinch_y = Setting("aspectDepend", "snap_pinchY");
scanlines.rotation = Setting("aspectDepend", "snap_rotation");
scanlines.preserve_aspect_ratio = false;
scanlines.alpha = 200;
}*/

//scanlines over cab screen --------------------------- END






//marquee  ------------------------------------------ START

/*if ( my_config["marquee_type"] == "marquee" )
{
local marqueeBkg = fe.add_image("black.png", fe.layout.height*0.1032, fe.layout.height*0.0763, fe.layout.height*0.3984, fe.layout.height*0.1349 );
marqueeBkg.skew_x = Setting("aspectDepend", "marquee_skewX");
marqueeBkg.skew_y = Setting("aspectDepend", "marquee_skewY");
marqueeBkg.pinch_x = Setting("aspectDepend", "marquee_pinchX");
marqueeBkg.pinch_y = Setting("aspectDepend", "marquee_pinchY");
marqueeBkg.rotation = Setting("aspectDepend", "marquee_rotation");
marqueeBkg.trigger = Transition.EndNavigation;
marqueeBkg.preserve_aspect_ratio = false;

local marquee = FadeArt("marquee", fe.layout.height*0.1032, fe.layout.height*0.0763, fe.layout.height*0.3984, fe.layout.height*0.1349 );
marquee.skew_x = Setting("aspectDepend", "marquee_skewX");
marquee.skew_y = Setting("aspectDepend", "marquee_skewY");
marquee.pinch_x = Setting("aspectDepend", "marquee_pinchX");
marquee.pinch_y = Setting("aspectDepend", "marquee_pinchY");
marquee.rotation = Setting("aspectDepend", "marquee_rotation");
marquee.trigger = Transition.EndNavigation;
marquee.preserve_aspect_ratio = false;
}*/

//marquee  ------------------------------------------ END



//marquee (with emulator name)   ---------------------- START

/*if ( my_config["marquee_type"] == "emulator-name" )

{
local emuMarquee = fe.add_image("[Emulator]" + "-marquee.jpg", fe.layout.height*0.1032, fe.layout.height*0.0763, fe.layout.height*0.3984, fe.layout.height*0.1349 );
emuMarquee.skew_x = Setting("aspectDepend", "marquee_skewX");
emuMarquee.skew_y = Setting("aspectDepend", "marquee_skewY");
emuMarquee.pinch_x = Setting("aspectDepend", "marquee_pinchX");
emuMarquee.pinch_y = Setting("aspectDepend", "marquee_pinchY");
emuMarquee.rotation = Setting("aspectDepend", "marquee_rotation");
emuMarquee.trigger = Transition.EndNavigation;
emuMarquee.preserve_aspect_ratio = false;
}*/



//marquee (my own image) ----------------------------- START

/*if ( my_config["marquee_type"] == "my-own" )
{
local myOwnMarquee = fe.add_image("my-own-marquee.jpg", fe.layout.height*0.1032, fe.layout.height*0.0763, fe.layout.height*0.3984, fe.layout.height*0.1349 );
myOwnMarquee.skew_x = Setting("aspectDepend", "marquee_skewX");
myOwnMarquee.skew_y = Setting("aspectDepend", "marquee_skewY");
myOwnMarquee.pinch_x = Setting("aspectDepend", "marquee_pinchX");
myOwnMarquee.pinch_y = Setting("aspectDepend", "marquee_pinchY");
myOwnMarquee.rotation = Setting("aspectDepend", "marquee_rotation");
myOwnMarquee.trigger = Transition.EndNavigation;
myOwnMarquee.preserve_aspect_ratio = false;
}*/






//cabinet image -------------------------------------- START
/*local cab = fe.add_image( "cab_body.png", 0, 0, fe.layout.height*0.992, fe.layout.height*1.008);
cab.preserve_aspect_ratio = true;*/

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
  text.font = "open sans";
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


//LCD display text under cab screen ------------------------------------------------ START

if ( my_config["lcdRight"] == "filter" )
{
local lcdRightText = fe.add_text( "[FilterName]", fe.layout.height*0.1584, fe.layout.height*0.6208, fe.layout.height*0.4, fe.layout.height*0.04 );
lcdRightText.set_rgb( 59, 45, 3 );
lcdRightText.align = Align.Right;
lcdRightText.rotation = -6.6;
lcdRightText.font="digital-7 (italic)";  // free font (for personal use) - can be downloaded here: http://www.dafont.com/digital-7.font
}


if ( my_config["lcdRight"] == "rom-filename" )
{
local lcdRightText = fe.add_text( "[Name]", fe.layout.height*0.1584, fe.layout.height*0.6208, fe.layout.height*0.4, fe.layout.height*0.04 );
lcdRightText.set_rgb( 59, 45, 3 );
lcdRightText.align = Align.Right;
lcdRightText.rotation = -6.6;
lcdRightText.font="digital-7 (italic)";  // free font (for personal use) - can be downloaded here: http://www.dafont.com/digital-7.font
}


if ( my_config["lcdRight"] == "display-name" )
{
local lcdRightText = fe.add_text( "[DisplayName]", fe.layout.height*0.1584, fe.layout.height*0.6208, fe.layout.height*0.4, fe.layout.height*0.04 );
lcdRightText.set_rgb( 59, 45, 3 );
lcdRightText.align = Align.Right;
lcdRightText.rotation = -6.6;
lcdRightText.font="digital-7 (italic)";  // free font (for personal use) - can be downloaded here: http://www.dafont.com/digital-7.font
}


if ( my_config["lcdRight"] == "emulator" )
{
local lcdRightText = fe.add_text( "[Emulator]", fe.layout.height*0.1584, fe.layout.height*0.6208, fe.layout.height*0.4, fe.layout.height*0.04 );
lcdRightText.set_rgb( 59, 45, 3 );
lcdRightText.align = Align.Right;
lcdRightText.rotation = -6.6;
lcdRightText.font="digital-7 (italic)";  // free font (for personal use) - can be downloaded here: http://www.dafont.com/digital-7.font
}


if ( my_config["lcdRight"] == "off" )
{
local lcdRightText = fe.add_text( my_config["lcdRightText"], fe.layout.height*0.1584, fe.layout.height*0.6208, fe.layout.height*0.4, fe.layout.height*0.04 );
lcdRightText.set_rgb( 59, 45, 3 );
lcdRightText.align = Align.Right;
lcdRightText.rotation = -6.6;
lcdRightText.font="digital-7 (italic)";  // free font (for personal use) - can be downloaded here: http://www.dafont.com/digital-7.font
}

//LCD display text --------------------------------------------------------- END


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
		p -= slot; // TODO: isnt this just p = 0?!

		slot++;

		if ( slot < 0 ) slot=0;
		if ( slot >=10 ) slot=10;

		m_obj.x = x[slot] + p * ( x[slot+1] - x[slot] );
		m_obj.y = y[slot] + p * ( y[slot+1] - y[slot] );
		m_obj.width = w[slot] + p * ( w[slot+1] - w[slot] );
		m_obj.height = h[slot] + p * ( h[slot+1] - h[slot] );
		m_obj.rotation = r[slot] + p * ( r[slot+1] - r[slot] );
		m_obj.alpha = a[slot] + p * ( a[slot+1] - a[slot] );
	}
};

class Wheel
{
  wheel_x = [ flx*0.87, flx*0.79, flx*0.765, flx*0.745, flx*0.73, flx*0.72, flx*0.67, flx*0.72, flx*0.73, flx*0.745, flx*0.765, flx*0.79, ];
  wheel_y = [ -fly*0.22, -fly*0.105, fly*0.0, fly*0.105, fly*0.215, fly*0.325, fly*0.436, fly*0.61, fly*0.72 fly*0.83, fly*0.935, fly*0.99, ];
  wheel_w = [ flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.28, flw*0.18, flw*0.18, flw*0.18, flw*0.18, flw*0.18, ];
  wheel_a = [  80,  80,  80,  80,  80,  80, 255,  80,  80,  80,  80,  80, ];
  wheel_h = [  flw*0.07,  flw*0.07,  flw*0.07,  flw*0.08,  flw*0.08,  flw*0.08, flw*0.11,  flw*0.07,  flw*0.07,  flw*0.07,  flw*0.07,  flw*0.07, ];
  //wheel_r = [  31,  26,  21,  16,  11,   6,   0, -11, -16, -21, -26, -31, ];
  wheel_r = [ 30, 25, 20, 15, 10, 5, 0, -10, -15, -20, -25, -30, ];
  num_arts = Setting("aspectDepend", "wheelNumElements");  // number of elements in wheel - depending on screen aspect ratio
  wheel_entries = [];

  constructor(frontend)
  {

    local i = 0;
    for (i; i < num_arts / 2; i++) {
    	wheel_entries.push( WheelEntry(wheel_x, wheel_y, wheel_w, wheel_a, wheel_h, wheel_r) );
    }

    local remaining = num_arts - wheel_entries.len();

    // we do it this way so that the last wheelentry created is the middle one showing the current
    // selection (putting it at the top of the draw order)

    for (i = 0; i < remaining; i++) {
    	wheel_entries.insert( num_arts/2, WheelEntry(wheel_x, wheel_y, wheel_w, wheel_a, wheel_h, wheel_r) );
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
    name = fe.game_info(Info.Name);
    year = fe.game_info(Info.Year);
    manufacturer = fe.game_info(Info.Manufacturer);

    this.displayName();
    this.displayMeta();
  }

  function getName()
  {
    return name.len() ? name : "[unknown]";
  }

  function getMeta()
  {
    if (year.len() && manufacturer.len()) {
      return year + ", " + manufacturer;
    } else if (year.len()) {
      return year;
    } else if (manufacturer.len()) {
      return manufacturer;
    }
    return "Witchert, 2015";
  }

  function displayName()
  {
    local x = 100;
    local y = fe.layout.height - 142;
    local w = fe.layout.width - x;
    local h = 0;
    local text = add_outlined_text(getName(), x, y, w, h, outline, 42);
    text.set_rgb(color[0], color[1], color[2]);
  }

  function displayMeta()
  {
    local x = 110;
    local y = fe.layout.height - 186;
    local w = fe.layout.width - x;
    local h = 0;
    local text = add_outlined_text(getMeta(), x, y, w, h, outline, 24);
    text.set_rgb(color[0], color[1], color[2]);
  }
}

local gameInfo = GameInfo(fe);
local wheel = Wheel(fe);
