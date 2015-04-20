<!-- загрузка изображений из админки на сервер -->

<script type="text/javascript" src="{$obj->mSiteUrl}view/js/jquery/jquery.form.js"></script>
<script type="text/javascript">
$(function()
{
    var div_controle_group  = null;
    var completed           = '0%';
    var factor              = 3;
    var class_name          = '';
    var block_id            = $('.tabbable').attr('id').split('-');

    for (var i = 0; i < block_id.length; i++) {
        class_name += block_id[i][0].toUpperCase() + block_id[i].substr(1);
    }

    $('input.fileupload')
        .on('change',
            function()
            {
                var self           = $(this);
                div_controle_group = self.parents('div.control-group');

                self
                    .parents('form.form-horizontal')
                    .ajaxSubmit({
                        url:        '/amishka-admin/ajax/' + class_name + '/file-upload/' + self.attr('typefile') + '/' + self.attr('name').split('[')[0] + '/',
                        dataType:   'json',
                        beforeSend: function()
                        {
                            div_controle_group
                                .find('.btn.fileinput-button')
                                .addClass('disabled');
                            div_controle_group
                                .find('.progressbar')
                                .empty()
                                .width(0)
                                .html(completed)
                                .show();
                        },
                        uploadProgress: function(event, position, total, percentComplete)
                        {
                            div_controle_group
                                .find('.progressbar')
                                .width(percentComplete * factor)
                                .html(percentComplete + '%');
                        },
                        complete: function(response)
                        {
                            try {
                                var answer = $.parseJSON(response.responseText);

                                div_controle_group
                                    .find('.progressbar')
                                    .width(100 * factor)
                                    .html('100%');

                                if (answer.result) {
                                    div_controle_group
                                        .find('input[type=hidden][name=' + self.attr('name') + ']')
                                        .val(answer.file_name);
                                    div_controle_group
                                        .find('.btn.fileinput-button')
                                        .removeClass('disabled');
                                    div_controle_group
                                        .find('.progressbar')
                                        .hide();
                                    div_controle_group
                                        .find('div.add-image')
                                        .removeClass('invisible')
                                        .find('img')
                                        .attr('src', '{$obj->mLinkToSiteResourcesDir}' + '{$obj->mLinkToItemsResourcesDir}' + answer.file_name);

                                    if (self.hasClass('main-image')) {
                                        div_controle_group
                                            .prevAll()
                                            .find('img#thumbnail')
                                            .attr('src', '{$obj->mLinkToSiteResourcesDir}' + '{$obj->mLinkToItemsThumbnailsResourcesDir}' + '{$obj->mThumbnailImagePrefix}' + answer.file_name);
                                        div_controle_group
                                            .prevAll()
                                            .find('img#preview')
                                            .attr('src', '{$obj->mLinkToSiteResourcesDir}' + '{$obj->mLinkToItemsPreviewResourcesDir}' + '{$obj->mPreviewImagePrefix}' + answer.file_name);
                                    }

                                }
                                else {
                                    Dialog.show('Ошибка!', answer.message);
                                    div_controle_group
                                        .find('.progressbar')
                                        .hide();
                                }
                            }
                            catch (e) {
                                Dialog.show('Ошибка!', 'Возникла ошибка при загрузке файла. Попробуйте повторить действие позже.');
                                div_controle_group
                                    .find('.progressbar')
                                    .hide();
                            }
                        }
                    });

                return false;
            });
});
</script>