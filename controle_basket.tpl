<!-- управление корзиной пользователя -->

<script type="text/javascript">
$(function()
{
    function refreshBasket(element)
    {
        var parent_block = element.parents('tbody');
        var tr_block = parent_block.find('tr[pid]');
        var total_count = 0;
        var total_amount = 0;

        for (var i = 0; i < tr_block.length; i++) {
            var count_prod = $(tr_block[i]).find('select').val();
            var price_prod = $(tr_block[i]).find('td[pp]').attr('pp');
            var total_price = (count_prod * price_prod).toFixed(2);

            total_count += parseInt(count_prod);
            total_amount += parseInt(total_price);

            $('td.product-price-info input.total-price', $(tr_block[i])).val(total_price);
        }

        $('tr.well span#b-count-products').text(total_count);
        $('tr.well span#b-total-amount').text(total_amount.toFixed(2));

        return false;
    }


    $('.btn-action-delete')
        .on('click',
            function()
            {
                var parent_block = $(this).parents('tbody');
                var delete_block = $(this).parents('tr[pid]');
                var product_id = $(this).parents('tr[pid]').attr('pid');

                console.log('product_id = ' + product_id);
                console.log('delete_block = ', delete_block);

                $.post(
                    "/ajax/Basket/delete/",
                    {
                        productId:  product_id
                    },
                    function(response)
                    {
                        if (response.result) {
                            $(delete_block).hide('slow');
                            $(delete_block).remove();
                            Dialog.showInfo('Удаление товара', response.message, null, null, function(){ window.location = window.location.href; });

                            //var count_tr = $(parent_block).find('tr');

                            //if (!count_tr.length) {
                            //    $('.basket-sticker span#bs-count-products').text('0');
                            //    $('.basket-sticker span#bs-total-amount').text('0');
                            //    $('a.basket span#b-info').text('пусто');
                            //    $(parent_block).parent('table').hide();
                            //    $('.content-block').html('<p>Ваша корзина пуста.</p>');
                            //}
                        }
                        else {
                            Dialog.showInfo('Ошибка!', response.message, true);
                        }
                    },
                    "json"
                );

                return false;
            });

    $('select.quantity')
        .change(function()
        {
            refreshBasket($(this));

            return false;
        });

    $('.btn-action-refresh')
        .on('click',
            function()
            {
                refreshBasket($(this));

                return false;
            });

     $('button.btn-action-checkout')
        .on('click',
            function()
            {
                var form = $('form.form-horizontal');

                //return false;
            });

});
</script>