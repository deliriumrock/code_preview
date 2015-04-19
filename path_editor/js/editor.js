window.onload = function()
{
	createStage();

    switchScreenMode();

    colorPath = COLOR_NORMAL_PATH;

    $('body')
        .on('keyup',
            function(e)
            {
                if (e.keyCode == 46)  // Del
                {
                    deletePoint();
                }
            });

    $('.fileupload-new')
        .on('click',
            function()
            {
                $('#fileupload-name').show();
            });

    $('#remove-file')
        .on('click',
            function()
            {
                if (imgLevel)
                {
                    imgLevel.destroy = true;
                    imgLevel = null;
                }

                $('#fileupload-name').hide(50);
            });

    $('.fileupload').fileupload();
    $('#file-name').change(function()
    {
        if (imgLevel)
        {
            imgLevel.destroy = true;
            imgLevel = null;
        }

		var val = $(this).val();

        setTimeout(function()
        {
            var bmp = $('.fileupload-preview > img')[0];

            imgLevel = new Sprite(bmp, screenMode.width, screenMode.height);
            imgLevel.x = screenMode.width / 2;
            imgLevel.y = screenMode.height / 2;
            stage.addChild(imgLevel);
            imgLevel.setZIndex(0);

            //$('.fileupload-preview > img').hide();
			$('#fileupload-name span').text(val);
        },
        200);
    });

    $('#path-switch')
        .on('change',
            function()
            {
                changePath(this);
            });

    $('#select-btn')
        .on('click',
            function()
            {
                $('#dialog').modal('hide');
                selectLevel($('#path-select').val());
            });

    $('#pointer-z-index')
        .on('change keyup blur',
            function()
            {
                setPointerZIndex();
            });
};

function createStage()
{
    if (stage)
    {
        stage.stop();
    }

    stage = new Stage('screen', screenMode.width, screenMode.height);
	stage.delay = 1000/24;
	stage.onposttick = postTick;
	stage.start();

    createBackground();
}

function createBackground()
{
    back = new Sprite(null, screenMode.width, screenMode.height);
    back.x = screenMode.width / 2;
    back.y = screenMode.height / 2;
    back.onmousedown = mouseDown;
    back.onmousemove = mouseMove;
    back.onmouseup = mouseUp;
    back.static = true;
    stage.addChild(back);
}

function generateJSON()
{
    if (!cycle.length)
    {
        for (var c = 0; c < path.length; c++)
        {
            cycle[c] = 0;
        }
    }

    levelJSON = {
        path: [],
        cycle: [],
        guns: [],
        archs: [],
    };

    for (var i = 0; i < path.length; i++)
    {
        levelJSON.path[i] = [];

        for (var j = 0; j < path[i].length; j++)
        {
            levelJSON.path[i].push({
                x: Math.round((path[i][j].x - screenMode.width / 2) / 2),
                y: Math.round((path[i][j].y - screenMode.height / 2) / 2),
                z: (path[i][j].z ? +path[i][j].z : 0),
                v: (path[i][j].v ? +path[i][j].v : 0),
                h: (path[i][j].h ? +path[i][j].h : 0),
            });
        }
    }

    levelJSON.cycle = cycle;

    for (var i = 0; i < gunPoints.length; i++)
    {
        levelJSON.guns.push({
            x: Math.round((gunPoints[i].x - screenMode.width / 2) / 2),
            y: Math.round((gunPoints[i].y - screenMode.height / 2) / 2)
        });
    }

    $('#level-json').val(JSON.stringify(levelJSON, null, 4));
}

function loadJSON()
{
    for (var i = 0; i < path.length; i++)
    {
        for (var j = 0; j < path[i].length; j++)
        {
            stage.removeChild(path[i][j]);
        }
    }

    for (var i = 0; i < gunPoints.length; i++)
    {
        stage.removeChild(gunPoints[i]);
    }

    path = [];
    gunPoints = [];

    var val = $('#level-json').val().replace(/(\/\*[\w\'\s\r\n\*]*\*\/)|(\/\/[\w\s\']*)|(\<![\-\-\s\w\>\/]*\>)/g, '');

	levelJSON = JSON.parse(val);

    if (levelJSON.path.length)
    {
        for (var i = 0; i < levelJSON.path.length; i++)
        {
            $('#path-switch').append('<option ' + (!i ? 'selected="selected"' : '') + ' value="' + i + '">Путь №' + (i + 1) + '</option>');
        }

        pathNumber = 0;
    }

    var point = null;

    for (var i = 0; i < levelJSON.path.length; i++)
    {
        if (!path[i])
        {
            path[i] = [];
        }

        for (var j = 0; j < levelJSON.path[i].length; j++)
        {
            point = createPoint(
                    null,
                    (levelJSON.path[i][j].x * 2 + screenMode.width / 2),
                    (levelJSON.path[i][j].y * 2 + screenMode.height / 2),
                    (typeof(levelJSON.path[i][j].z) != 'undefined' ? levelJSON.path[i][j].z : 0),
                    (typeof(levelJSON.path[i][j].v) != 'undefined' ? levelJSON.path[i][j].v : 1),
                    (typeof(levelJSON.path[i][j].h) != 'undefined' ? levelJSON.path[i][j].h : 1));
            path[i].push(point);
        }
    }

    createGunPoints(levelJSON.guns, true);

    cycle = levelJSON.cycle;
    archsPoints = levelJSON.archs;
}

function saveData()
{

}

function switchScreenMode()
{
    var left = 0;
    var top = -663;

    if (screenMode.width == 960)
    {
        screenMode.width = 640;
        screenMode.height = 960;
        left = 160;
        top = -983;
        landscapeMode = false;
    }
    else
    {
        screenMode.width = 960;
        screenMode.height = 640;
        landscapeMode = true;
    }

    $('#screen')
            .attr('width', screenMode.width)
            .attr('height', screenMode.height);
    $('.fileupload-preview.thumbnail')
            .width(screenMode.width)
            .height(screenMode.height)
            .css({
                'left': left + 'px',
                'top':  top + 'px'
            });
    $('#backImage')
            .width(screenMode.width)
            .height(screenMode.height);
    createStage();

    var point = null;

    for (var i = 0; i < path.length; i++)
    {
        for (var j = 0; j < path[i].length; j++)
        {
            point = createPoint(
                    null,
                    path[i][j].x,
                    path[i][j].y,
                    (typeof(path[i][j].z) != 'undefined' ? path[i][j].z : 0),
                    (typeof(path[i][j].v) != 'undefined' ? path[i][j].v : 1));
            path[i][j] = point;
        }
    }
}


function createGunPoints(gunPointArr, loadFlag)
{
    for (var i = 0; i < gunPointArr.length; i++)
    {
        var pos_x = loadFlag ? (screenMode.width / 2 + gunPointArr[i].x * 2) : gunPointArr[i].x;
        var pos_y = loadFlag ? (screenMode.height / 2 + gunPointArr[i].y * 2) : gunPointArr[i].y;

        var spr = new Graphics.circle(pos_x, pos_y, 15);
        spr.lineWidth = 0;
        spr.fillColor = 'rgba(14, 126, 238, 1)';
        spr.onmousedown = pointGunMouseDown;
        spr.onmouseup = pointGunMouseUp;
        spr.GUN = true;
        stage.addChild(spr);

        gunPoints.push(spr);
    }
}

function getAbsCoords(e)
{
	return {x: e.x + e.target.x, y: e.y + e.target.y};
}

function getSelectedPointIx(point)
{
    var pnt = point ? point : selectedPoint;

	for (var i = 0; i < path.length; i++)
	{
        for (var j = 0; j < path[i].length; j++)
        {
            if (path[i][j] == pnt)
            {
                return {number: i, id: j};
            }
        }
	}

	return -1;
}

function startPath()
{
    if (!path.length)
    {
        return false;
    }

    if (path[path.length - 1].length > 1)
    {
        inactiveSelectedPoint();

        pathNumber++;
        path[pathNumber] = [];

        $('#path-switch option').removeAttr('selected');
        $('#path-switch').append('<option value="' + pathNumber + '" selected="selected">Путь №' + (pathNumber + 1) + '</option>');
    }
}

function changePath(element)
{
    inactiveSelectedPoint();

    pathNumber = $(element).val();
    backlight_path_flag = true;

    if (bezierPathFlag[pathNumber])
    {
        $('#set-bezier-path').addClass('active');
    }
    else
    {
        $('#set-bezier-path').removeClass('active');
    }

    var t = setTimeout(function()
    {
        clearTimeout(t);
        backlight_path_flag = false;
    },
    500);
}

function movePath(element)
{
    $('button').removeClass('active');
    pathResetFlags();
    gunResetFlags();

    if ($(element).hasClass('active')) {
        $(element).removeClass('active');
        modeMovePath = false;
    }
    else {
        $(element).addClass('active');
        modeMovePath = true;
    }
}

function flipPath(flip)
{
    if (!path.length)
    {
        return;
    }

    var farthestsSprite = null;
    var p_number = path.length;
    var edgeSprite = null;

    path[p_number] = [];

    if (flip == FLIP_HORIZONTAL)
    {
        edgeSprite = searchPointAxis(AXIS_X);

    }
    else if (flip == FLIP_VERTICAL)
    {
        edgeSprite = searchPointAxis(AXIS_Y);
    }

    var ix = getSelectedPointIx(edgeSprite);

    path[p_number].push(createPoint(null, edgeSprite.x, edgeSprite.y, edgeSprite.z, edgeSprite.v));

    for (var i = ix.id - 1; i >= 0; i--)
    {
        var x = (flip == FLIP_HORIZONTAL) ? edgeSprite.x + (edgeSprite.x - path[pathNumber][i].x) : path[pathNumber][i].x;
        var y = (flip == FLIP_HORIZONTAL) ? path[pathNumber][i].y : edgeSprite.y + (edgeSprite.y - path[pathNumber][i].y);

        path[p_number].unshift(createPoint(null, x, y));
    }

    for (var i = ix.id + 1; i < path[pathNumber].length; i++)
    {
        var x = (flip == FLIP_HORIZONTAL) ? edgeSprite.x + (edgeSprite.x - path[pathNumber][i].x) : path[pathNumber][i].x;
        var y = (flip == FLIP_HORIZONTAL) ? path[pathNumber][i].y : edgeSprite.y + (edgeSprite.y - path[pathNumber][i].y);

        path[p_number].push(createPoint(null, x, y));
    }

    $('#path-switch').append('<option value="' + p_number + '">Путь №' + (p_number + 1) + '</option>');
}

function moveGunPointMode(element)
{
    $('button').removeClass('active');
    pathResetFlags();

    if ($(element).hasClass('active')) {
        $(element).removeClass('active');
        modeMoveGunPoint = false;
    }
    else {
        $(element).addClass('active');
        modeMoveGunPoint = true;
    }
}

function pointGunMouseDown(e)
{
    focusGunPoint = e.target;

    if (delete_gun_flag)
    {
        focusGunPoint = null;

        deleteGunPoint(e);
    }

    if (modeMoveGunPoint)
    {
        focusGunPoint.startDrag(e.x, e.y);
    }

    return false;
}

function pointGunMouseUp(e)
{
    if (modeMoveGunPoint)
    {
        e.target.stopDrag();
        $('#move-gun-point').removeClass('active');
        modeMoveGunPoint = false;
    }

    focusGunPoint = null;

    return false;
}

function mouseDown(e)
{
    resetMergeFlag();

    if (set_gun_flag)
    {
        createGunPoints([{
            x: getAbsCoords(e).x,
            y: getAbsCoords(e).y,
        }]);

        set_gun_flag = false;

        $('#set-gun-flag').removeClass('active');

        return false;
    }

    if (modeMovePath)
    {
        for (var i = 0; i < path[pathNumber].length; i++)
        {
            path[pathNumber][i].begin_x = path[pathNumber][i].x;
            path[pathNumber][i].begin_y = path[pathNumber][i].y;
        }

        startMovePathPos.x = e.x;
        startMovePathPos.y = e.y;
        move_path_flag = true;

        return false;
    }

	if (!modeAdd)
	{
        mousedown_flag = true;
        inactiveSelectedPoint();

		return false;
	}

	var point = createPoint(e);

	if (!selectedPoint)
    {
        if (!path[pathNumber])
        {
            path[pathNumber] = [];
        }

        if (path[pathNumber].length > 0)
        {
            point.z = path[pathNumber][path[pathNumber].length - 1].z;
            point.v = path[pathNumber][path[pathNumber].length - 1].v;

            $('#pointer-z-index').val(point.z);
            $('#pointer-visible > span')
                .removeClass()
                .addClass(point.v ? 'glyphicon glyphicon-eye-open' : 'glyphicon glyphicon-eye-close');
        }

        path[pathNumber].push(point);
    }
	else
	{
		var ix = getSelectedPointIx();

        if (ix !== -1)
        {
            path[ix.number].splice(ix.id + 1, 0, point);
        }
	}

    needCalc();

    if (path[pathNumber].length > 1 && !$('#path-switch').children().length)
    {
        $('#path-switch').append('<option value="' + pathNumber + '" selected="selected">Путь №' + (pathNumber + 1) + '</option>');
    }
}

function mouseMove(e)
{
    if (mousedown_flag)
    {
        if (selectArea.x1 < 0 && selectArea.y1 < 0)
        {
            selectArea.x1 = e.x + e.target.x;
            selectArea.y1 = e.y + e.target.y;
        }

        selectArea.x2 = e.x + e.target.x;
        selectArea.y2 = e.y + e.target.y;

        addToMergePointers(selectArea.x1, selectArea.y1, selectArea.x2, selectArea.y2);
    }
    else if (move_path_flag)
    {
        var step_x = e.x - startMovePathPos.x;
        var step_y = e.y - startMovePathPos.y;

        for (var i = 0; i < path[pathNumber].length; i++)
        {
            path[pathNumber][i].x = path[pathNumber][i].begin_x + step_x;
            path[pathNumber][i].y = path[pathNumber][i].begin_y + step_y;
        }
    }

    needCalc();
}

function mouseUp()
{
    mousedown_flag = false;
    move_path_flag = false;
    focusGunPoint = null;
    modeMoveGunPoint = false;
    $('#move-gun-point').removeClass('active');

    if (mergeSelectedPointers.length < 2 || (mergeSelectedPointers[0].number == mergeSelectedPointers[1].number))
    {
        resetMergeFlag();
    }

    selectArea = {
        x1: -1,
        y1: -1,
        x2: -1,
        y2: -1
    };
}

function setPointerZIndex()
{
    selectedPoint.z = $('#pointer-z-index').val();
}

function setPointerVisible()
{
    selectedPoint.v = selectedPoint.v ? 0 : 1;
    $('#pointer-visible > span')
            .removeClass()
            .addClass(selectedPoint.v ? 'glyphicon glyphicon-eye-open' : 'glyphicon glyphicon-eye-close');
}

function setPointerHitTest()
{
    selectedPoint.h = selectedPoint.h ? 0 : 1;
    $('#pointer-hittest > span')
            .removeClass()
            .addClass(selectedPoint.h ? 'glyphicon glyphicon-thumbs-up' : 'glyphicon glyphicon-thumbs-down');
}

function pointMouseDown(e)
{
    resetMergeFlag();
    inactiveSelectedPoint(true);

    if (selectedPoint == e.target)
    {
        inactiveSelectedPoint();
        $('#pointer-z-index').val("");
        $('#pointer-visible > span')
            .removeClass()
            .addClass('glyphicon glyphicon-eye-open');
    }
    else
    {
        selectedPoint = e.target;

        $('#pointer-z-index').val(selectedPoint.z);
        $('#pointer-visible > span')
            .removeClass()
            .addClass(selectedPoint.v ? 'glyphicon glyphicon-eye-open' : 'glyphicon glyphicon-eye-close');
        $('#pointer-hittest > span')
            .removeClass()
            .addClass(selectedPoint.h ? 'glyphicon glyphicon-thumbs-up' : 'glyphicon glyphicon-thumbs-down');
    }

	e.target.startDrag(e.x, e.y);
	return false;
}

function pointMouseMove(e)
{
    needCalc();

	return false;
}

function pointMouseUp(e)
{
	e.target.stopDrag();

    if (path[pathNumber][0].x != path[pathNumber][path[pathNumber].length - 1].x
        || path[pathNumber][0].y != path[pathNumber][path[pathNumber].length - 1].y)
    {
        cycle[pathNumber] = 0;
    }
    else if (path[pathNumber][0].x == path[pathNumber][path[pathNumber].length - 1].x
             && path[pathNumber][0].y == path[pathNumber][path[pathNumber].length - 1].y)
    {
        cycle[pathNumber] = 1;
    }

	return false;
}

function createPoint(e, x, y, z, v, h)
{
    var c = e ? getAbsCoords(e) : null;
	var point = new Sprite(null, 9, 9);

	point.fillColor = COLOR_NORMAL_POINT;
	point.x = (typeof(x) != 'undefined' ? x : c.x);
	point.y = (typeof(y) != 'undefined' ? y : c.y);
    point.z = (typeof(z) != 'undefined' ? z : 0);  // zIndex
    point.v = (typeof(v) != 'undefined' ? v : 1);  // visible
    point.h = (typeof(h) != 'undefined' ? h : 1);  // hitTest flag
    point.POINT = true;
	point.onmousedown = pointMouseDown;
	point.onmousemove = pointMouseMove;
	point.onmouseup = pointMouseUp;
	stage.addChild(point);

    return point;
}

function addPoint(element)
{
    $('#move-path').removeClass('active');
    modeMovePath = false;

    if ($(element).hasClass('active')) {
        $(element).removeClass('active');
        modeAdd = false;
    }
    else {
        $(element).addClass('active');
        modeAdd = true;
    }
}

function refreshPointers()
{
    path = [];
    pathNumber = 0;
    selectedPoint = null;
    calcPoints = [];

    gunPoints = [];
    focusGunPoint = null;

    $('#path-switch').empty();

    for (var i = 0; i < stage.objects.length; i++)
    {
        if (stage.objects[i].POINT || stage.objects[i].GUN)
        {
            stage.objects[i].destroy = true;
        }
    }
}

function alinePoint(aline)
{
    if (!selectedPoint)
    {
        return;
    }

    var ix = getSelectedPointIx();

    if (!path[ix.number][ix.id + 1])
    {
        return;
    }

    if (aline == ALINE_X)
    {
        path[ix.number][ix.id + 1].x = path[ix.number][ix.id].x;
    }
    else if (aline == ALINE_Y)
    {
        path[ix.number][ix.id + 1].y = path[ix.number][ix.id].y;
    }
}

function mergePointers()
{
    if (!mergeSelectedPointers.length)
    {
        return;
    }

    path[mergeSelectedPointers[1].number][mergeSelectedPointers[1].id].x = mergeSelectedPointers[0].x;
    path[mergeSelectedPointers[1].number][mergeSelectedPointers[1].id].y = mergeSelectedPointers[0].y;

    resetMergeFlag();
}

function mergeStartAndFinish()
{
    var point = createPoint(null, path[pathNumber][0].x, path[pathNumber][0].y);

    path[pathNumber].push(point);
    cycle[pathNumber] = 1;
}

function deletePoint()
{
	if(!selectedPoint) return;

	var ix = getSelectedPointIx();
	path[ix.number].splice(ix.id, 1);

    selectedPoint.destroy = true;
	selectedPoint = null;
}

function addToMergePointers(x1, y1, x2, y2)
{
    var tmp = 0;

    if (x1 > x2)
    {
        tmp = x1;
        x1 = x2;
        x2 = tmp;
    }

    if (y1 > y2)
    {
        tmp = y1;
        y1 = y2;
        y2 = tmp;
    }

    for (var i = 0; i < path.length; i++)
    {
        for (var j = 0; j < path[i].length; j++)
        {
            if (!path[i][j].MERGE &&
                (path[i][j].x >= x1) && (path[i][j].x <= x2) &&
                (path[i][j].y >= y1) && (path[i][j].y <= y2) &&
                (mergeSelectedPointers.length < 2))
            {
                mergeSelectedPointers.push({
                    number: i,
                    id:     j,
                    x:      path[i][j].x,
                    y:      path[i][j].y
                });

                path[i][j].MERGE = true;
            }
        }
    }
}

function pathResetFlags()
{
    modeAdd = false;
    modeMovePath = false;
}

function gunResetFlags()
{
    modeMoveGunPoint = false;
    set_gun_flag = false;
    delete_gun_flag = false;
    select_gun_point = false;
    focusGunPoint = null;
}

function setGunPoint()
{
    pathResetFlags();
    set_gun_flag = true;

    $('button').removeClass('active');
    $('#set-gun-flag').addClass('active');
}

function deleteGunPointFlag()
{
    pathResetFlags();
    delete_gun_flag = true;

    $('#delete-gun-flag').addClass('active');
    $('#add-point').removeClass('active');
}

function deleteGunPoint(e)
{
    if (delete_gun_flag)
    {
        for (var i = 0; i < gunPoints.length; i++)
        {
            if (gunPoints[i] == e.target)
            {
                gunPoints.splice(i, 1);
                break;
            }
        }

        stage.removeChild(e.target);
        $('#delete-gun-flag').removeClass('active');
    }

    delete_gun_flag = false;
}

function setBezierPath()
{
    bezierPathFlag[pathNumber] = bezierPathFlag[pathNumber] ? !bezierPathFlag[pathNumber] : true;
    $('#set-bezier-path').toggleClass('active');

    if (bezierPathFlag[pathNumber])
    {
        calcPoints[pathNumber] = [];
    }
}

function resetMergeFlag()
{
    for (var m = 0; m < mergeSelectedPointers.length; m++)
    {
        path[mergeSelectedPointers[m].number][mergeSelectedPointers[m].id].MERGE = false;
    }

    mergeSelectedPointers = [];
}

function calculate()
{
    calcPoints = [];

    for (var n = 0; n < path.length; n++)
    {
        if (path[n].length < 2 || bezierPathFlag[n]) return;

        var path_local = path[n];
        var cnt = document.getElementById("placesCount").value * 1;

        cnt--;

        var pathLen = 0, w, h, len;

        for(var i=0; i<path_local.length-1; i++)
        {
            w = path_local[i].x - path_local[i+1].x;
            h = path_local[i].y - path_local[i+1].y;
            pathLen += Math.sqrt(w*w + h*h);
        }

        var curPoint = {x: path_local[0].x, y: path_local[0].y};
        calcPoints[n] = [{x: curPoint.x, y: curPoint.y}];

        var nextPointIx = 1;
        var step = pathLen/cnt;

		step = 40;
		cnt = Math.floor(pathLen/step);

        var stepLen, lenPassed;

        while(cnt > 0)
        {
            stepLen = 0;
            lenPassed = 0;

            while(lenPassed < step)
            {
                w = curPoint.x - path_local[nextPointIx].x;
                h = curPoint.y - path_local[nextPointIx].y;
                len = Math.sqrt(w*w + h*h);

                //достаточно места на текущем отрезке
                if(len >= step - lenPassed)
                {
                    stepLen = step - lenPassed;
                    lenPassed += stepLen;
                }
                //места недостаточно, сдвигаемся
                else
                {
                    lenPassed += len;
                    curPoint = {x: path_local[nextPointIx].x, y: path_local[nextPointIx].y};
                    nextPointIx++;
                    //если вывалились за пределы пути, значит это последняя точка и на этом все
                    if(nextPointIx >= path_local.length)
                    {
                        stepLen = step - lenPassed;
                        lenPassed = step;
                        nextPointIx--;
                    }
                }
            }

            var angle = Math.atan2(path_local[nextPointIx].y - curPoint.y, path_local[nextPointIx].x - curPoint.x);
            var p = new Vector(stepLen, 0);
            p.rotate(-angle);

            curPoint.x += p.x;
            curPoint.y += p.y;

            calcPoints[n].push({x: curPoint.x, y: curPoint.y});

            cnt--;
        }
    }
}

function inactiveSelectedPoint(noDeletePoint)
{
    if (selectedPoint)
    {
        selectedPoint.fillColor = COLOR_NORMAL_POINT;
    }

    if (!noDeletePoint)
    {
        selectedPoint = null;
    }
}

function needCalc()
{
//    if (calcPoints.length)
//    {
//        calculate();
//    }
}

function searchFarthestSprites(axis)
{
    var minSprite = null;
    var maxSprite = null;

    if (axis == AXIS_X)
    {
        for (var i = 0; i < path[pathNumber].length; i++)
        {
            if (!minSprite || minSprite.x >= path[pathNumber][i].x)
            {
                minSprite = path[pathNumber][i];
            }

            if (!maxSprite || maxSprite.x <= path[pathNumber][i].x)
            {
                maxSprite = path[pathNumber][i];
            }
        }
    }
    else if (axis == AXIS_Y)
    {
        for (var i = 0; i < path[pathNumber].length; i++)
        {
            if (!minSprite || minSprite.y >= path[pathNumber][i].y)
            {
                minSprite = path[pathNumber][i];
            }

            if (!maxSprite || maxSprite.y <= path[pathNumber][i].y)
            {
                maxSprite = path[pathNumber][i];
            }
        }
    }

    return {min: minSprite, max: maxSprite};
}

function searchPointAxis(axis)
{
    var farthest_sprites = searchFarthestSprites(axis);
    var distance_edge = (axis == AXIS_X ? (screenMode.width - farthest_sprites.max.x) : (screenMode.height - farthest_sprites.max.y));

    if (axis == AXIS_X)
    {
        if (distance_edge < farthest_sprites.min.x)
        {
            distance_edge = farthest_sprites.min.x;
        }

        return (distance_edge == farthest_sprites.min.x ? farthest_sprites.min : farthest_sprites.max);
    }
    else if (axis == AXIS_Y)
    {
        if (distance_edge < farthest_sprites.min.y)
        {
            distance_edge = farthest_sprites.min.y;
        }

        return (distance_edge == farthest_sprites.min.y ? farthest_sprites.min : farthest_sprites.max);
    }
}


function postTick()
{
    for (var i = 0; i < path.length; i++)
    {
        if (backlight_path_flag && pathNumber == i)
        {
            colorPath = COLOR_SELECT_PATH;
            widthPath = WIDTH_SELECT_PATH;
        }
        else
        {
            colorPath = COLOR_NORMAL_PATH;
            widthPath = WIDTH_NORMAL_PATH;
        }

        var pathPoints = [];

        for (var p = 0; p < path[i].length; p++)
        {
            pathPoints.push({
                x: path[i][p].x,
                y: path[i][p].y
            });
        }

        if (bezierPathFlag[i])
        {
            pathPoints = Utils.getBezierCurve(pathPoints);
        }

        for (var j = 0; j < pathPoints.length - 1; j++)
        {
            stage.drawLine(pathPoints[j].x, pathPoints[j].y, pathPoints[j + 1].x, pathPoints[j + 1].y, widthPath, colorPath);
        }
    }

	if (selectedPoint)
	{
		//stage.drawRectangle(selectedPoint.x, selectedPoint.y, 9, 9, COLOR_SELECT_POINT);
        selectedPoint.fillColor = COLOR_SELECT_POINT;
	}

    if (selectArea.x1 >= 0 && selectArea.y1 >= 0)
	{
		stage.drawPolygon(
            [
                {x: selectArea.x1, y: selectArea.y1},
                {x: selectArea.x1, y: selectArea.y2},
                {x: selectArea.x2, y: selectArea.y2},
                {x: selectArea.x2, y: selectArea.y1}
            ],
            1,
            COLOR_SELECT_POLYGON);
	}

    if (mergeSelectedPointers.length)
    {
        for (var m = 0; m < mergeSelectedPointers.length; m++)
        {
            stage.drawCircle(mergeSelectedPointers[m].x, mergeSelectedPointers[m].y, 8, 1, COLOR_MERGED_POINT);
        }
    }

	for (var i = 0; i < calcPoints.length; i++)
	{
        for (var j = 0; j < calcPoints[i].length; j++)
        {
            stage.drawCircle(calcPoints[i][j].x, calcPoints[i][j].y, 5, 1, COLOR_CALC_POINTS);
        }
	}
}