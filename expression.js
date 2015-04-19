// код генерации и преобразования в строку математического выражения для игры

var Expression =
{
    MINUS:          1,
    PLUS:           2,

    summand:        [],
    action:         [],
    string:         "",
    countSummand:   2,

    generate: function()
    {
        var i = 0;
        var sum = 0;
        var action = Expression.MINUS;
        var limit = 1;
        var countSummand = getRandomInt(2, Expression.countSummand);

        Expression.summand.push(getRandomInt(1, 3));

        while (i < countSummand - 1)
        {
            if (Expression.summand[i] <= 2)
            {
                action = getRandomInt(Expression.MINUS, Expression.PLUS);
            }

            sum = (!sum ? Expression.summand[i] : Expression.calcSum());

            if (sum < 2)
            {
                if (action == Expression.MINUS)
                {
                    action = Expression.PLUS;
                }

                limit = 2;
            }
            else if (sum == 2)
            {
                limit = 1;
            }
            else if (sum > 2)
            {
                action = Expression.MINUS;
                limit = 2;
            }

            if (Expression.checkCalcSum())
            {
                Expression.summand.push(getRandomInt(1, limit));
                Expression.action.push(action);

                i++;
            }
        }
    },

    calcSum: function()
    {
        var sum = Expression.summand[0];

        for (var i = 0; i < Expression.action.length; i++)
        {
            if (Expression.action[i] == Expression.MINUS)
            {
                sum -= Expression.summand[i + 1];
            }
            else
            {
                sum += Expression.summand[i + 1];
            }
        }

        return sum;
    },

    checkCalcSum: function()
    {
        if (Expression.calcSum() >= 1 && Expression.calcSum() <= 3)
        {
            return true;
        }

        return false;
    },

    convertToString: function()
    {
        var str = "";

        for (var i = 0; i < Expression.summand.length; i++)
        {
            str += Expression.summand[i];

            if (Expression.action[i])
            {
                str += (Expression.action[i] == Expression.MINUS ? '-' : '+');
            }
        }

        return str + "= ";
    },

    incrementCountSummand: function()
    {
        Expression.countSummand++;

        if (Expression.countSummand > MAX_COUNT_SUMMAND)
        {
            Expression.countSummand = MAX_COUNT_SUMMAND;
        }
    },

    reset: function(all)
    {
        Expression.summand = [];
        Expression.action = [];
        Expression.string = "";

        if (all)
        {
            Expression.countSummand = 2;
        }
    }
};

