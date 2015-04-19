var stage;
var back = null;
var landscapeMode = true;

var levelJSON = [];
var levelNumber = 0;

var imgLevel = null;

var path = [];
var pathNumber = 0;
var cycle = [];
var gunPoints = [];
var archsPoints = [];

var selectedPoint = null;
var focusGunPoint = null;
var mergeSelectedPointers = [];
var calcPoints = [];

var modeAdd = false;
var modeMovePath = false;
var modeMoveGunPoint = false;

var widthPath = 1;

var mousedown_flag = false;
var backlight_path_flag = false;
var move_path_flag = false;
var set_gun_flag = false;
var delete_gun_flag = false;
var select_gun_point = false;

var bezierPathFlag = [];

var screenMode = {
    width:  960,
    height: 640
};

var startMovePathPos = {
    x: 0,
    y: 0
};

var selectArea = {
        x1: -1,
        y1: -1,
        x2: -1,
        y2: -1
    };

var ALINE_X = 1;
var ALINE_Y = 2;

var AXIS_X = 1;
var AXIS_Y = 2;

var FLIP_HORIZONTAL = 1;
var FLIP_VERTICAL = 2;
var LEFT_FLIP = 3;
var RIGHT_FLIP = 4;
var UP_FLIP = 5;
var DOWN_FLIP = 6;

var WIDTH_NORMAL_PATH = 1;
var WIDTH_SELECT_PATH = 2;

// colors
var colorPath = '';
var colorPoint = '';

var COLOR_SELECT_POLYGON = '#0F0';

var COLOR_NORMAL_PATH = '#F00';
var COLOR_SELECT_PATH = '#000';

var COLOR_NORMAL_POINT = '#F66';
var COLOR_SELECT_POINT = '#00F';
var COLOR_MERGED_POINT = '#0F0';
var COLOR_CALC_POINTS = '#606';

var console = {log: function() {} };