// код создания и логики препятствий в игре

function Balcony()
{
	this.sprite         = null;
	this.spriteTop      = null;
	this.spriteBottom   = null;
	this.direction      = (getRandomInt(0, 1) ? 1 : -1);

	this.create = function(posY)
	{
		this.sprite = new Graphics.rectangle((this.direction > 0 ? 50 : getStageWidth() - 50), posY, 100, 46);
		this.sprite.lineWidth = 0;
		this.sprite.scaleX = this.direction;
		this.sprite.ID = new Date();
		this.sprite.BARRIER = true;
		this.sprite.typeBarrier = TYPE_BALCONY;
		stage.addChild(this.sprite);

		this.spriteTop = library.getSprite("animation/wum_1");
		this.spriteTop.x = 0;
		this.spriteTop.y = -this.sprite.height / 2 + 2;
		this.spriteTop.scaleX = -1;
		this.spriteTop.animated = true;
		this.spriteTop.changeFrameDelay = 40;
		this.spriteTop.onchangeframe = function(e)
		{
			if (e.target.currentFrame == e.target.totalFrames - 1)
			{
				if (e.target.currentLayer != e.target.totalLayers - 1)
				{
					e.target.currentLayer++;
				}
				else
				{
					e.target.currentLayer = 0;
				}

				e.target.currentFrame = 0;
			}
		};
		this.sprite.addChild(this.spriteTop);

		this.spriteBottom = library.getSprite("barrier/balcony");
		this.spriteBottom.x = 0;
		this.spriteBottom.y = 0;
		this.sprite.addChild(this.spriteBottom);

		return this.sprite;
	};

	this.move = function()
	{
		this.sprite.moveTo(
			this.sprite.x,
			Sumo.sprite.y - 80,
			1000,
			Easing.quartic.easeOut);
	};

	this.collision = function()
	{
		var pos_x = this.spriteTop.x;
		var pos_y = this.spriteTop.y - 2;
		var z_index = this.spriteTop.zIndex;

		this.spriteTop.destroy = true;
		this.spriteTop.visible = false;

		this.spriteTop = library.getSprite("animation/wum_2");
		this.spriteTop.x = pos_x;
		this.spriteTop.y = pos_y;
		this.spriteTop.totalFramesInLayers = 46;
		this.spriteTop.currentFramesInLayers = 0;
		this.spriteTop.changeFrameDelay = 40;
		this.spriteTop.scaleX = -1;
		this.spriteTop.onchangeframe = function(e)
		{
			e.target.currentFramesInLayers++;

			if (e.target.currentFramesInLayers == e.target.totalFramesInLayers)
			{
				e.target.currentFramesInLayers = 0;
				e.target.currentFrame = 0;
				e.target.currentLayer = 0;
				e.target.stop();
			}

			if (e.target.currentFrame == e.target.totalFrames - 1)
			{
				if (e.target.currentLayer != e.target.totalLayers - 1)
				{
					e.target.currentLayer++;
				}

				e.target.currentFrame = 0;
			}
		};
		this.sprite.addChild(this.spriteTop);
		this.spriteTop.setZIndex(z_index);
	};

	this.destroy = function()
	{
		this.sprite.destroy = true;
		this.sprite.visible = false;
		this.sprite = null;
	};
};

//////////////////
function Lantern()
{
	var self = this;

	this.sprite = null;
	this.face	= null;

	this.create = function(posY)
	{
		var pos_x = getRandomInt(LIMIT_SIDE, getStageWidth() - LIMIT_SIDE);

		this.sprite = new Graphics.circle(pos_x, posY, 25);
		this.sprite.lineWidth = 0;
		this.sprite.ID = new Date();
		this.sprite.BARRIER = true;
		this.sprite.typeBarrier = TYPE_CHINA_LANTERN;
		stage.addChild(this.sprite);

		this.face = library.getSprite("barrier/lantern");
		this.face.x = 0;
		this.face.y = 0;
		this.sprite.addChild(this.face);

		return this.sprite;
	};

	this.move = function()
	{
		var pos_x = (this.sprite.y < stage.viewport.y
			? this.sprite.x
			: getRandomInt(this.sprite.width / 2, getStageWidth() - this.sprite.width / 2));
		var pos_y = (this.sprite.y < stage.viewport.y
			? getRandomInt(stage.viewport.y + this.sprite.height / 2, Sumo.sprite.y - 80)
			: getRandomInt(stage.viewport.y + this.sprite.height / 2, stage.viewport.y + getStageHeight() - this.sprite.height / 2));
		var easing = (this.sprite.y < stage.viewport.y ? Easing.quartic.easeOut : Easing.linear.easeInOut);
		var delay = (this.sprite.y < stage.viewport.y ? 1000 : getRandomInt(60000, 120000));

		this.sprite.moveTo(
			pos_x,
			pos_y,
			delay,
			easing,
			function()
			{
				self.move();
			});
	};

	this.destroy = function()
	{
		this.sprite.destroy = true;
		this.sprite.visible = false;
	};
};

/////////////////
function Bird()
{
	this.sprite = null;
	this.face = null;
	this.COLOR_BIRD = "";
};

Bird.prototype.create = function(name, posY, type)
{
	var pos_x = getRandomInt(LIMIT_SIDE, getStageWidth() - LIMIT_SIDE);

	this.sprite = new Graphics.circle(pos_x, posY, 13);
	this.sprite.lineWidth = 0;
	this.sprite.BARRIER = true;
	this.sprite.typeBarrier = type;
	this.sprite.collisionFlag = false;
	stage.addChild(this.sprite);

	this.face = library.getSprite(name);
	this.face.x = 0;
	this.face.y = 0;
	this.face.animated = true;
	this.face.changeFrameDelay = 40;
	this.face.NAME = name;
	this.face.damageFlag = false;
	this.face.onchangeframe = function(e)
	{
		if (e.target.currentFrame == e.target.totalFrames - 1)
		{
			if (e.target.currentLayer != e.target.totalLayers - 1)
			{
				e.target.currentLayer++;
			}

			e.target.currentFrame = 0;
		}
	};
	this.sprite.addChild(this.face);
};

Bird.prototype.move = function()
{
	if (this.sprite.damageFlag)
	{
		return false;
	}

	var self = this;
	var pos_x = (this.sprite.y < stage.viewport.y
		? this.sprite.x
		: getRandomInt(this.sprite.width / 2, getStageWidth() - this.sprite.width / 2));
	var pos_y = (this.sprite.y < stage.viewport.y
		? getRandomInt(stage.viewport.y + this.sprite.height / 2, Sumo.sprite.y - 80)
		: getRandomInt(stage.viewport.y + this.sprite.height / 2, stage.viewport.y + getStageHeight() - this.sprite.height / 2));
	var easing = (this.sprite.y < stage.viewport.y ? Easing.quartic.easeOut : Easing.linear.easeInOut);
	var delay = (this.sprite.y < stage.viewport.y ? 1000 : getRandomInt(4000, 5000));

	if (this.sprite.collisionFlag)
	{
		pos_x = this.sprite.x;
		pos_y = stage.viewport.y + getStageHeight() + 250;
		delay = 1000;
		this.sprite.collisionFlag = false;
		this.sprite.damageFlag = true;
	}

	this.sprite.scaleX = (pos_x < this.sprite.x ? -1 : 1);
	this.sprite.tweenX = stage.createTween(this.sprite, "x", this.sprite.x, pos_x, delay, easing);
	this.sprite.tweenY = stage.createTween(this.sprite, "y", this.sprite.y, pos_y, delay, easing);

	this.sprite.tweenX.onfinish = this.sprite.tweenY.onfinish = function()
	{
		self.move();
	};

	this.sprite.tweenX.onchange = this.sprite.tweenY.onchange = function(e)
	{
		if (pause_flag)
		{
			e.target.pause();
			var t = stage.setInterval(function()
			{
				if (!pause_flag)
				{
					t.destroy = true;
					e.target.play();
				}
			}, 10);
		}

		if (self.sprite.collisionFlag)
		{
			e.target.stop();
			self.move();
		}
	};

	this.sprite.tweenX.play();
	this.sprite.tweenY.play();
};

Bird.prototype.collision = function(name)
{
	var self = this;
	var pos_x = this.face.x;
	var pos_y = this.face.y - 2;
	var z_index = this.face.zIndex;

	this.sprite.collisionFlag = true;

	this.face.destroy = true;
	this.face.visible = false;

	this.face = library.getSprite(name ? name : "animation/bird/"+ this.COLOR_BIRD +"/2");
	this.face.fallFly = (name ? 3 : 2);
	this.face.x = pos_x;
	this.face.y = pos_y;
	this.face.animated = true;
	this.face.changeFrameDelay = 40;
	this.face.totalFrames = (name ? 6 : 14);
	this.face.totalLayers = (name ? 4 : 1);
	this.face.currentFrame = 0;
	this.face.currentLayer = 0;
	this.face.onchangeframe = function(e)
	{
		if (e.target.currentFrame == e.target.totalFrames - 1)
		{
			if (e.target.fallFly == 2)
			{
				e.target.destroy = true;
				e.target.visible = false;

				self.collision("animation/bird/"+ this.COLOR_BIRD +"/3");
			}
			else if (e.target.fallFly == 3)
			{
				if (e.target.currentLayer != e.target.totalLayers - 1)
				{
					e.target.currentLayer++;
				}
				else
				{
					e.target.currentLayer = 0;
				}

				e.target.currentFrame = 0;
			}
		}
	};

	this.sprite.addChild(this.face);
	this.face.setZIndex(z_index);
};

Bird.prototype.destroy = function()
{
	this.sprite.destroy = true;
	this.sprite.visible = false;
};

///////////////////////
function BlueBird()
{
	BlueBird.superclass.constructor.call(this);

	this.COLOR_BIRD = "blue";
};

Utils.extend(BlueBird, Bird);

///////////////////////
function YellowBird()
{
	YellowBird.superclass.constructor.call(this);

	this.COLOR_BIRD = "yellow";
};

Utils.extend(YellowBird, Bird);

///////////////////////
function RedBird()
{
	RedBird.superclass.constructor.call(this);

	this.COLOR_BIRD = "red";
};

Utils.extend(RedBird, Bird);

RedBird.prototype.move = function()
{
	var self = this;
	var pos_x = (this.sprite.y < stage.viewport.y
		? this.sprite.x
		: getRandomInt(this.sprite.width / 2, getStageWidth() - this.sprite.width / 2));
	var pos_y = (this.sprite.y < stage.viewport.y
		? getRandomInt(stage.viewport.y + this.sprite.height / 2, Sumo.sprite.y - 80)
		: getRandomInt(stage.viewport.y + this.sprite.height / 2, stage.viewport.y + getStageHeight() - this.sprite.height / 2));
	var easing = (this.sprite.y < stage.viewport.y ? Easing.quartic.easeOut : Easing.linear.easeInOut);
	var delay = (this.sprite.y < stage.viewport.y ? 1000 : getRandomInt(4000, 5000));

	this.sprite.scaleX = (pos_x < this.sprite.x ? -1 : 1);
	this.sprite.tweenX = stage.createTween(this.sprite, "x", this.sprite.x, pos_x, delay, easing);
	this.sprite.tweenY = stage.createTween(this.sprite, "y", this.sprite.y, pos_y, delay, easing);

	this.sprite.tweenX.onfinish = this.sprite.tweenY.onfinish = function()
	{
		self.move();
	};

	this.sprite.tweenX.onchange = this.sprite.tweenY.onchange = function(e)
	{
		if (pause_flag)
		{
			e.target.pause();
			var t = stage.setInterval(function()
			{
				if (!pause_flag)
				{
					t.destroy = true;
					e.target.play();
				}
			}, 10);
		}
	};

	this.sprite.tweenX.play();
	this.sprite.tweenY.play();
};

RedBird.prototype.collision = function(name)
{
	var self = this;
	var pos_x = this.face.x;
	var pos_y = this.face.y - 2;
	var z_index = this.face.zIndex;

	this.face.destroy = true;
	this.face.visible = false;

	this.face = library.getSprite(name ? name : "animation/bird/red/2");
	this.face.fallFly = (name ? 3 : 2);
	this.face.x = pos_x;
	this.face.y = pos_y;
	this.face.animated = true;
	this.face.changeFrameDelay = 40;
	this.face.totalFrames = (name ? 14 : 12);
	this.face.totalLayers = 1;
	this.face.currentFrame = 0;
	this.face.currentLayer = 0;
	this.face.onchangeframe = function(e)
	{
		if (e.target.currentFrame == e.target.totalFrames - 1)
		{
			if (e.target.fallFly == 2)
			{
				e.target.destroy = true;
				e.target.visible = false;

				self.collision("animation/bird/red/1");
			}
			else if (e.target.fallFly == 3)
			{
				if (e.target.currentLayer != e.target.totalLayers - 1)
				{
					e.target.currentLayer++;
				}
				else
				{
					e.target.currentLayer = 0;
				}

				e.target.currentFrame = 0;
			}
		}
	};

	this.sprite.addChild(this.face);
	this.face.setZIndex(z_index);
};



