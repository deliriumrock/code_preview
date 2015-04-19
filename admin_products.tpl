<!-- информация о продуктах в админке -->

{* admin_products.tpl *}
{load_presentation_object filename="AdminProducts" assign="obj"}

{if $obj->mErrorMessage.404}

    {include file=$obj->mTemplateError404}

{else}

<div class="navbar navbar-fixed-top subnav">
    <div class="navbar-inner">
        <div class="content">
            <h4>Каталог <i class="icon-chevron-right"></i> Товары</h4>
        </div>
    </div>
</div>

<div class="content">
    <div class="page-header">
        <h3>Каталог <i class="icon-chevron-right"></i> Товары</h3>
        <p>Здесь вы можете управлять товарами каталога интернет-магазина.</p>
    </div>
    {if $obj->mErrorMessage.module}
        <div class="alert alert-error">
            {$obj->mErrorMessage.module}
        </div>
    {/if}
    <div class="well well-small">
        <form class="form-horizontal filter"
              method="post"
              action="{$obj->mLinkToCurrentModuleAdmin}">
            <div class="control-group">
                <label class="control-label" for="select_department">Раздел:</label>
                <div class="controls">
                    <select id="select_department"
                            class="span2"
                            name="department_id">
                        <option value="0"></option>
                    {section name=i loop=$obj->mDepartments}
                        <option value="{$obj->mDepartments[i].department_id}" {if $obj->mDepartmentId == $obj->mDepartments[i].department_id}selected{/if}>
                            {$obj->mDepartments[i].name}
                        </option>
                    {/section}
                    </select>
                </div>
            </div>
        </form>
        <form class="form-horizontal filter"
              method="post"
              action="{$obj->mLinkToCurrentModuleAdmin}">
            <div class="control-group">
                <label class="control-label" for="select_category">Категория:</label>
                <div class="controls">
                    <select id="select_category"
                            class="span2"
                            name="category_id">
                        <option value="0"></option>
                    {section name=i loop=$obj->mCategories}
                        <option value="{$obj->mCategories[i].category_id}" {if $obj->mCategoryId == $obj->mCategories[i].category_id}selected{/if}>
                            {$obj->mCategories[i].name}
                        </option>
                    {/section}
                    </select>
                </div>
            </div>
        </form>
        <form class="form-horizontal filter"
              method="post"
              action="{$obj->mLinkToCurrentModuleAdmin}">
            <div class="control-group">
                <label class="control-label" for="select_subcategory">Подкатегория:</label>
                <div class="controls">
                    <select id="select_subcategory"
                            class="span2"
                            name="subcategory_id">
                        <option value="0"></option>
                    {section name=i loop=$obj->mSubcategories}
                        <option value="{$obj->mSubcategories[i].subcategory_id}" {if $obj->mSubcategoryId == $obj->mSubcategories[i].subcategory_id}selected{/if}>
                            {$obj->mSubcategories[i].name}
                        </option>
                    {/section}
                    </select>
                </div>
            </div>
        </form>
        <div class="clearfix"></div>
    </div>
    <div class="well well-small">
        <form class="form-horizontal filter"
              method="post"
              action="{$obj->mLinkToCurrentModuleAdmin}">
            <div class="control-group">
                <label class="control-label" for="select_country">Страна:</label>
                <div class="controls">
                    <select id="select_country"
                            class="span2"
                            name="country_id">
                        <option value="0"></option>
                    {section name=i loop=$obj->mCountries}
                        <option value="{$obj->mCountries[i].country_id}" {if $obj->mCountryId == $obj->mCountries[i].country_id}selected{/if}>
                            {$obj->mCountries[i].name}
                        </option>
                    {/section}
                    </select>
                </div>
            </div>
        </form>
        <form class="form-horizontal filter"
              method="post"
              action="{$obj->mLinkToCurrentModuleAdmin}">
            <div class="control-group">
                <label class="control-label" for="select_brand">Бренд:</label>
                <div class="controls">
                    <select id="select_brand"
                            class="span2"
                            name="brand_id">
                        <option value="0"></option>
                    {section name=i loop=$obj->mBrands}
                        <option value="{$obj->mBrands[i].brand_id}" {if $obj->mBrandId == $obj->mBrands[i].brand_id}selected{/if}>
                            {$obj->mBrands[i].name}
                        </option>
                    {/section}
                    </select>
                </div>
            </div>
        </form>
        <div class="clearfix"></div>
    </div>
    {if $obj->mMessage}
        <div class="alert alert-success">
            <button type="button" class="close" data-dismiss="alert">×</button>
            {$obj->mMessage}
        </div>
    {/if}
    {*<div>
        <div class="control-group" style="float: right;">
            <div class="controls">
                <form method="post"
                      action="{$obj->mLinkToCurrentModuleAdmin}">
                    <label class="checkbox" for="show-visible-product">
                        <input type="checkbox"
                               id="show-visible-product"
                               name="show_visible_product"
                               value="{$obj->mProducts[i].visible}"
                               {if $obj->mProducts[i].visible == 1}checked{/if}> Не отображать скрытые товары
                    </label>
                </form>
            </div>
        </div>
    </div>*}
    <div class="clearfix"></div>
    <div id="products" class="tabbable tabs-left">
        <ul class="nav nav-tabs span2">
            <li {if !$obj->mErrorMessage.add}class="active"{/if} ><a data-toggle="tab" href="#lA">Все товары</a></li>
            {if ($obj->mDepartmentId && $obj->mCategoryId) || ($obj->mCountryId && $obj->mBrandId)}
                <li {if $obj->mErrorMessage.add}class="active"{/if}><a data-toggle="tab" href="#lB">Добавить новый</a></li>
            {/if}
        </ul>
        <div class="tab-content span10">
            <div id="lA" class="tab-pane {if !$obj->mErrorMessage.add}active{/if}">
            {if $obj->mErrorMessage.update.permission ||
                $obj->mErrorMessage.edit.permission ||
                $obj->mErrorMessage.delete.permission ||
                $obj->mErrorMessage.restore.permission}
                <div class="alert alert-error">
                    {$obj->mErrorMessage.update.permission}
                    {$obj->mErrorMessage.edit.permission}
                    {$obj->mErrorMessage.delete.permission}
                    {$obj->mErrorMessage.restore.permission}
                </div>
            {/if}
            {if $obj->mErrorMessage.deleted && !$obj->mErrorMessage.delete.permission}
                <div class="alert alert-error">
                    {$obj->mErrorMessage.delete}
                </div>
            {/if}
            {if $obj->mProductsCount == 0}
                <p class="no-items-found">Нет ни одного товара!</p>
            {else}
                <form class="form-horizontal"
                      method="post"
                      action="{$obj->mLinkToCurrentModuleAdmin}"
                      enctype="multipart/form-data">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th width="10">№</th>
                                <th width="100"></th>
                                {*<th width="80">Артикул</th>*}
                                <th width="150">Название</th>
                                <th width="70">Краткое описание</th>
                                <th width="60">Цена</th>
                                {*<th width="60">Продано</th>*}
                                <th width="70">Атрибуты</th>
                                <th width="80">Статус</th>
                                <th width="80"></th>
                            </tr>
                        </thead>
                        <tbody>
                        {section name=i loop=$obj->mProducts}
                            {if $obj->mEditItem == $obj->mProducts[i].product_id}
                                <tr>
                                    <td colspan="8" class="edit-item">
                                        <a name="edit-item"></a>
                                        <div class="control-group">
                                            <label class="control-label" for="input-date-added">Дата добавления:</label>
                                            <div class="controls">
                                                <input class="span2"
                                                       id="input-date-added"
                                                       type="text"
                                                       name="date_added"
                                                       readonly
                                                       value="{$obj->mProducts[i].date_added|date_format:"%H:%M %d-%m-%Y"}">
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-count-purchases">Количество продаж:</label>
                                            <div class="controls">
                                                <input class="span2"
                                                       id="input-count-purchases"
                                                       type="text"
                                                       name="count_purchases"
                                                       readonly
                                                       value="{$obj->mProducts[i].count_purchases}">
                                            </div>
                                        </div>
                                        <div class="g-separator-1"></div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-article">Артикул:</label>
                                            <div class="controls">
                                                <input class="span2"
                                                       id="input-article"
                                                       type="text"
                                                       name="article"
                                                       value="{$obj->mProducts[i].article}">
                                            </div>
                                        </div>
                                        <div class="control-group{if $obj->mErrorMessage.update.name} error{/if}">
                                            <label class="control-label" for="input-name">Название:</label>
                                            <div class="controls">
                                                <input class="input-xxlarge"
                                                       id="input-name"
                                                       type="text"
                                                       name="name"
                                                       value="{$obj->mProducts[i].name|escape:'html'}">
                                                {if $obj->mErrorMessage.update.name}
                                                    <span class="help-inline">{$obj->mErrorMessage.update.name}</span>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="control-group{if $obj->mErrorMessage.update.description} error{/if}">
                                            <label class="control-label" for="textarea-description">Описание:</label>
                                            <div class="controls">
                                                <textarea id="textarea-description"
                                                          class="editor input-xxlarge"
                                                          name="description">
                                                    {$obj->mProducts[i].description|escape:'html'}
                                                </textarea>
                                                {if $obj->mErrorMessage.update.description}
                                                    <span class="help-inline">{$obj->mErrorMessage.update.description}</span>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="textarea-brief">Краткое описание:</label>
                                            <div class="controls">
                                                <textarea id="textarea-brief"
                                                          class="editor input-xxlarge"
                                                          name="brief">
                                                    {$obj->mProducts[i].brief|escape:'html'}
                                                </textarea>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-price">Цена:</label>
                                            <div class="controls">
                                                <input size="8"
                                                       class="span2"
                                                       id="input-price"
                                                       type="text"
                                                       name="price"
                                                       value="{$obj->mProducts[i].price}">
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-discounted-price">Цена со скидкой:</label>
                                            <div class="controls">
                                                <input size="8"
                                                       class="span2"
                                                       id="input-discounted-price"
                                                       type="text"
                                                       name="discounted_price"
                                                       value="{$obj->mProducts[i].discounted_price}">
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-availability">Наличие:</label>
                                            <div class="controls">
                                                <input size="8"
                                                       class="span2"
                                                       id="input-availability"
                                                       type="text"
                                                       name="availability"
                                                       value="{$obj->mProducts[i].availability}">
                                            </div>
                                        </div>
                                        {section name=j loop=$obj->mAttributes}
                                        <div class="control-group">
                                            <label class="control-label" for="sel-attribute-value">{$obj->mAttributes[j].name}:</label>
                                            <div class="controls">
                                                <div class="multiselect span2">
                                                {section name=k loop=$obj->mAttributes[j].attribute_values}
                                                    <label class="checkbox control-value" for="check-av-{$obj->mAttributes[j].attribute_values[k].attribute_value_id}">
                                                        <input type="checkbox"
                                                               id="check-av-{$obj->mAttributes[j].attribute_values[k].attribute_value_id}"
                                                               name="attribute_value[]"
                                                               value="{$obj->mAttributes[j].attribute_values[k].attribute_value_id}"
                                                               {section name=l loop=$obj->mProducts[i].attributes}
                                                                   {section name=n loop=$obj->mProducts[i].attributes[l].attribute_values}
                                                                       {if $obj->mAttributes[j].attribute_values[k].attribute_value_id == $obj->mProducts[i].attributes[l].attribute_values[n].attribute_value_id}checked{/if}
                                                                   {/section}
                                                               {/section}> {$obj->mAttributes[j].attribute_values[k].name}
                                                    </label>
                                                {/section}
                                                </div>
                                            </div>
                                        </div>
                                        {/section}
                                        <div class="control-group">
                                            <label class="control-label" for="sel-category">Каталог:</label>
                                            <div class="controls">
                                                <div class="multiselect input-xxlarge" id="sel-catalog">
                                                    {section name=j loop=$obj->mDepartments}
                                                        <span class="dep-title {if $smarty.section.j.first}first{/if}"><span>{$obj->mDepartments[j].name}</span></span>
                                                        {section name=k loop=$obj->mDepartments[j].categories}
                                                            {assign var=c_prev_value value=0}
                                                            <label class="checkbox cat-categories control-value" for="check-c-{$obj->mDepartments[j].categories[k].category_id}">
                                                                <input type="checkbox"
                                                                       id="check-c-{$obj->mDepartments[j].categories[k].category_id}"
                                                                       name="category[]"
                                                                       value="{$obj->mDepartments[j].categories[k].category_id}"
                                                                       {section name=l loop=$obj->mProducts[i].locations}
                                                                           {if $obj->mDepartments[j].categories[k].category_id == $obj->mProducts[i].locations[l].category_id && $obj->mProducts[i].locations[l].category_id != $c_prev_value}{assign var=c_prev_value value=$obj->mProducts[i].locations[l].category_id}checked{/if}
                                                                       {/section}> {$obj->mDepartments[j].categories[k].name}
                                                            </label>
                                                            {section name=n loop=$obj->mDepartments[j].categories[k].subcategories}
                                                                {assign var=prev_value value=0}
                                                                <label class="checkbox cat-subcategories control-value{if $smarty.section.n.last} last{/if}" for="check-sc-{$obj->mDepartments[j].categories[k].subcategories[n].subcategory_id}">
                                                                    <input type="checkbox"
                                                                           id="check-sc-{$obj->mDepartments[j].categories[k].subcategories[n].subcategory_id}"
                                                                           name="subcategory[]"
                                                                           value="{$obj->mDepartments[j].categories[k].subcategories[n].subcategory_id}"
                                                                           {section name=l loop=$obj->mProducts[i].locations}
                                                                               {if $obj->mDepartments[j].categories[k].subcategories[n].subcategory_id == $obj->mProducts[i].locations[l].subcategory_id && $obj->mProducts[i].locations[l].subcategory_id != $prev_value}{assign var=prev_value value=$obj->mProducts[i].locations[l].subcategory_id}checked{/if}
                                                                           {/section}> {$obj->mDepartments[j].categories[k].subcategories[n].name}
                                                                </label>
                                                            {/section}
                                                        {/section}
                                                    {/section}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="sel-category">Бренды:</label>
                                            <div class="controls">
                                                <div class="multiselect input-xxlarge" id="sel-catalog">
                                                    {section name=j loop=$obj->mCountries}
                                                        <span class="dep-title {if $smarty.section.j.first}first{/if}"><span>{$obj->mCountries[j].name}</span></span>
                                                        {section name=k loop=$obj->mCountries[j].brands}
                                                            <label class="radio cat-categories control-value" for="check-b-{$obj->mCountries[j].brands[k].brand_id}">
                                                                <input type="radio"
                                                                       id="check-b-{$obj->mCountries[j].brands[k].brand_id}"
                                                                       name="brand[]"
                                                                       value="{$obj->mCountries[j].brands[k].brand_id}"
                                                                       {section name=l loop=$obj->mProducts[i].brand}
                                                                           {if $obj->mCountries[j].brands[k].brand_id == $obj->mProducts[i].brand[l].brand_id}checked{/if}
                                                                       {/section}> {$obj->mCountries[j].brands[k].name}
                                                            </label>
                                                        {/section}
                                                    {/section}
                                                </div>
                                            </div>
                                        </div>
                                        <div class="control-group{if $obj->mErrorMessage.update.alias} error{/if}">
                                            <label class="control-label" for="input-alias">Псевдоним:<br/><small>(отображение в URL)</small></label>
                                            <div class="controls">
                                                <input type="text"
                                                       id="input-alias"
                                                       class="input-xxlarge"
                                                       name="alias"
                                                       value="{$obj->mProducts[i].alias}">
                                                {if $obj->mErrorMessage.update.alias}
                                                    <span class="help-inline">{$obj->mErrorMessage.update.alias}</span>
                                                {/if}
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <div class="controls">
                                                <label class="checkbox" for="check-sale">
                                                    <input type="checkbox"
                                                           id="check-sale"
                                                           name="sale"
                                                           value="{$obj->mProducts[i].sale}"
                                                           {if $obj->mProducts[i].sale == 1}checked{/if}> Участвует в распродаже
                                                </label>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <div class="controls">
                                                <label class="checkbox" for="check-visible">
                                                    <input type="checkbox"
                                                           id="check-visible"
                                                           name="visible"
                                                           value="{$obj->mProducts[i].visible}"
                                                           {if $obj->mProducts[i].visible == 1}checked{/if}> Не отображать товар на сайте
                                                </label>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-meta-title">Meta заголовок:</label>
                                            <div class="controls">
                                                <input type="text"
                                                       id="input-meta-title"
                                                       class="input-xxlarge"
                                                       name="meta_title"
                                                       value="{$obj->mProducts[i].meta_title}">
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-meta-keywords">Meta ключевые слова:</label>
                                            <div class="controls">
                                                <input type="text"
                                                       id="input-meta-keywords"
                                                       class="input-xxlarge"
                                                       name="meta_keywords"
                                                       value="{$obj->mProducts[i].meta_keywords}">
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-meta-description">Meta описание:</label>
                                            <div class="controls">
                                                <textarea id="input-meta-description"
                                                          class="input-xxlarge"
                                                          rows="3"
                                                          name="meta_description">{$obj->mProducts[i].meta_description}</textarea>
                                            </div>
                                        </div>
                                        <div class="g-separator-1"></div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-file">Эскиз товара:</label>
                                            <div class="controls">
                                                <div class="add-image thumbnail">
                                                    <img id="thumbnail" src="{if $obj->mProducts[i].images.thumbnail}{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsThumbnailsResourcesDir}{$obj->mProducts[i].images.thumbnail[0]}{else}http://www.placehold.it/100x100/EFEFEF/AAAAAA&text=no+image{/if}" width="100" height="100" alt="">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="control-group">
                                            <label class="control-label" for="input-file">Превью товара:</label>
                                            <div class="controls">
                                                <div class="add-image thumbnail">
                                                    <img id="preview" src="{if $obj->mProducts[i].images.preview}{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsPreviewResourcesDir}{$obj->mProducts[i].images.preview[0]}{else}http://www.placehold.it/200x200/EFEFEF/AAAAAA&text=no+image{/if}" width="200" height="200" alt="">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="control-group{if $obj->mErrorMessage.update.main} error{/if}">
                                            <input type="hidden" name="main_old" value="{$obj->mProducts[i].images.main[0]}">
                                            <input type="hidden" name="main" value="{$obj->mProducts[i].images.main[0]}">
                                            <label class="control-label" for="input-main">Главное изображение:</label>
                                            <div class="controls">
                                                <span class="btn btn-success fileinput-button">
                                                    <span>Выберите изображение</span>
                                                    <input type="file"
                                                           id="input-main"
                                                           class="fileupload main-image input-xxlarge"
                                                           name="main"
                                                           typefile="product-main-image">
                                                </span>
                                                <button class="btn btn-action-delete"
                                                        name="delete_image"
                                                        title="Удалить изображение"
                                                        rel="main">
                                                    <i class="icon-remove"></i>
                                                </button>
                                                <div class="progressbar"></div>
                                                <div class="clearfix"></div>
                                                <div class="add-image thumbnail">
                                                    <img class="product-image" src="{if $obj->mProducts[i].images.main}{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mProducts[i].images.main[0]}{else}http://www.placehold.it/500x100/EFEFEF/AAAAAA&text=no+image{/if}" alt="">
                                                </div>
                                                {if $obj->mErrorMessage.update.main}
                                                    <span class="help-inline">{$obj->mErrorMessage.update.main}</span>
                                                {/if}
                                            </div>
                                        </div>
                                        {for $i=0 to $obj->mMaxProductImages}
                                            <div class="control-group">
                                                <input type="hidden" name="big_old_{$i}" value="{$obj->mProducts[i].images.big[$i]}">
                                                <input type="hidden" name="big_{$i}" value="{$obj->mProducts[i].images.big[$i]}">
                                                <label class="control-label" for="input-big-{$i}">Изображение ({$i + 1}):</label>
                                                <div class="controls">
                                                    <span class="btn btn-success fileinput-button">
                                                        <span>Выберите изображение</span>
                                                        <input type="file"
                                                               id="input-big-{$i}"
                                                               class="fileupload input-xxlarge"
                                                               name="big_{$i}"
                                                               typefile="product-big-image">
                                                    </span>
                                                    <button class="btn btn-action-delete"
                                                            name="delete_image"
                                                            title="Удалить изображение"
                                                            rel="big_{$i}">
                                                        <i class="icon-remove"></i>
                                                    </button>
                                                    <div class="progressbar"></div>
                                                    <div class="clearfix"></div>
                                                    <div class="add-image thumbnail">
                                                        <img class="product-image" src="{if $obj->mProducts[i].images.big[$i]}{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mProducts[i].images.big[$i]}{else}http://www.placehold.it/500x100/EFEFEF/AAAAAA&text=no+image{/if}" alt="">
                                                    </div>
                                                </div>
                                            </div>
                                        {/for}
                                        <div class="form-actions">
                                            <button type="submit"
                                                    name="submit_update_{$obj->mProducts[i].product_id}"
                                                    class="btn btn-primary btn-action-update">
                                                Обновить
                                            </button>
                                            <button type="submit"
                                                    name="cancel"
                                                    class="btn btn-action-cancel">
                                                Отмена
                                            </button>
                                            <button type="submit"
                                                    name="submit_delete_{$obj->mProducts[i].product_id}"
                                                    class="btn btn-action-delete">
                                                Удалить
                                            </button>
                                            {*if $obj->mProducts[i].deleted == 0}
                                                <button type="submit"
                                                        name="submit_delete_{$obj->mProducts[i].product_id}"
                                                        class="btn btn-action-delete">
                                                    Удалить
                                                </button>
                                            {else}
                                                <button type="submit"
                                                        name="submit_restore_{$obj->mProducts[i].product_id}"
                                                        class="btn btn-action-refresh">
                                                    Восстановить
                                                </button>
                                            {/if*}
                                        </div>
                                    </td>
                                </tr>
                            {else}
                                <tr id="{$obj->mProducts[i].product_id}"
                                    visible="{$obj->mProducts[i].visible}">
                                    <td><span id="index" class="{if $obj->mProducts[i].deleted == 0}badge {if $obj->mProducts[i].visible == 0}badge-success{/if}{/if}">{$obj->mStartItem + $smarty.section.i.index + 1}</span></td>
                                    <td><img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsThumbnailsResourcesDir}{$obj->mProducts[i].file}" width="100" height="100" /></td>
                                    {*<td>{$obj->mProducts[i].article}</td>*}
                                    <td>{$obj->mProducts[i].name}</td>
                                    <td>
                                        {if $obj->mProducts[i].brief}
                                            <a class="btn-popover btn btn-info btn-mini" title="" data-content="{$obj->mProducts[i].brief|strip_tags:false|escape:'html'}" data-original-title="Краткое содержание:">посмотреть</a>
                                        {/if}
                                    </td>
                                    <td>
                                        {if $obj->mProducts[i].discounted_price > 0}
                                            <del>{$obj->mProducts[i].price}</del><br>
                                            {$obj->mProducts[i].discounted_price}
                                        {else}
                                            {$obj->mProducts[i].price}
                                        {/if}
                                    </td>
                                    {*<td>{$obj->mProducts[i].count_purchases}</td>*}
                                    {*<td style="text-align: center;">{if $obj->mProducts[i].sale == 1}<i class="icon-ok"></i>{/if}</td>*}
                                    <td style="text-align: center;">
                                        {section name=j loop=$obj->mProducts[i].attributes}
                                            <p>{$obj->mProducts[i].attributes[j].attribute_name}:<br>
                                            {section name=n loop=$obj->mProducts[i].attributes[j].attribute_values}
                                                <nobr><span class="attr-label {if $obj->mProducts[i].attributes[j].attribute_values[n].attribute_value_id == $obj->mAttributesListId[i]}active{/if}" aid="{$obj->mProducts[i].attributes[j].attribute_id}" avid="{$obj->mProducts[i].attributes[j].attribute_values[n].attribute_value_id}">{$obj->mProducts[i].attributes[j].attribute_values[n].attribute_value_name}<input type="radio" value="{$obj->mProducts[i].attributes[j].attribute_values[n].attribute_value_id}" name="attribute_value_id[{$smarty.section.i.index}]" {if $obj->mProducts[i].attributes[j].attribute_values[n].attribute_value_id == $obj->mAttributesListId[i]}checked="checked"{/if}></span></nobr><br>
                                            {/section}
                                            </p>
                                        {/section}
                                    </td>
                                    <td>
                                        {if $obj->mProducts[i].deleted == 0}
                                            {if $obj->mProducts[i].visible == 0}
                                                <span class="status label label-success">видимый</span>
                                            {else}
                                                <span class="status label">невидимый</span>
                                            {/if}
                                        {else}
                                            <span class="status">удален</span>
                                        {/if}
                                    </td>
                                    <td>
                                        <nobr>
                                            <button class="btn btn-small btn-action-edit"
                                                    type="submit"
                                                    name="submit_edit_{$obj->mProducts[i].product_id}"
                                                    title="Редактировать">
                                                <i class="icon-pencil"></i>
                                            </button>
                                            <button class="btn btn-small btn-action-delete"
                                                    type="submit"
                                                    name="submit_delete_{$obj->mProducts[i].product_id}"
                                                    title="Удалить">
                                                <i class="icon-remove"></i>
                                            </button>
                                            {*if $obj->mProducts[i].deleted == 0}
                                                <button class="btn btn-small btn-action-delete"
                                                        type="submit"
                                                        name="submit_delete_{$obj->mProducts[i].product_id}"
                                                        title="Удалить">
                                                    <i class="icon-remove"></i>
                                                </button>
                                            {else}
                                                <button class="btn btn-small btn-action-refresh"
                                                        type="submit"
                                                        name="submit_restore_{$obj->mProducts[i].product_id}"
                                                        title="Восстановить">
                                                    <i class="icon-refresh"></i>
                                                </button>
                                            {/if*}
                                        </nobr>
                                    </td>
                                </tr>
                            {/if}
                        {/section}
                        </tbody>
                    </table>
                </form>

                {if $obj->mListPages}
                <div class="pagination pagination-centered {if $obj->mrTotalPages >= 17}pagination-mini{/if}">
                    <ul>
                        <li class="{if !$obj->mLinkToPreviousPage}disabled{/if}"><a href="{$obj->mLinkToPreviousPage}">«</a></li>
                        {section name=qa loop=$obj->mListPages}
                            <li class="{if $obj->mPage == $smarty.section.qa.index_next}active{/if}">
                                <a href="{$obj->mListPages[qa]}">{$smarty.section.qa.index_next}</a>
                            </li>
                        {/section}
                        <li class="{if !$obj->mLinkToNextPage}disabled{/if}"><a href="{$obj->mLinkToNextPage}">»</a></li>
                    </ul>
                </div>
                {/if}
            {/if}
            </div>
            <div id="lB" class="tab-pane {if $obj->mErrorMessage.add}active{/if}">
                {if $obj->mErrorMessage.add.permission}
                    <div class="alert alert-error">
                        {$obj->mErrorMessage.add.permission}
                    </div>
                {/if}
                <form class="form-horizontal"
                      method="post"
                      action="{$obj->mLinkToCurrentModuleAdmin}"
                      enctype="multipart/form-data">
                    <div class="control-group">
                        <label class="control-label" for="input-article">Артикул:</label>
                        <div class="controls">
                            <input class="span2"
                                   id="input-article"
                                   type="text"
                                   name="article"
                                   value="{$obj->mPost.article}">
                        </div>
                    </div>
                    <div class="control-group{if $obj->mErrorMessage.add.name} error{/if}">
                        <label class="control-label" for="input-name">Название:</label>
                        <div class="controls">
                            <input class="input-xxlarge"
                                   id="input-name"
                                   type="text"
                                   name="name"
                                   value="{$obj->mPost.name}">
                            {if $obj->mErrorMessage.add.name}
                                <span class="help-inline">{$obj->mErrorMessage.add.name}</span>
                            {/if}
                        </div>
                    </div>
                    <div class="control-group{if $obj->mErrorMessage.add.description} error{/if}">
                        <label class="control-label" for="textarea-description-add">Описание:</label>
                        <div class="controls">
                            <textarea id="textarea-description-add"
                                      class="editor input-xxlarge"
                                      name="description">
                                {$obj->mPost.description}
                            </textarea>
                            {if $obj->mErrorMessage.add.description}
                                <span class="help-inline">{$obj->mErrorMessage.add.description}</span>
                            {/if}
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="textarea-brief-add">Краткое описание:</label>
                        <div class="controls">
                            <textarea id="textarea-brief-add"
                                      class="editor input-xxlarge"
                                      name="brief">
                                {$obj->mPost.brief}
                            </textarea>
                        </div>
                    </div>
                    <div class="control-group{if $obj->mErrorMessage.add.price} error{/if}">
                        <label class="control-label" for="input-price">Цена:</label>
                        <div class="controls">
                            <input size="8"
                                   class="span2"
                                   id="input-price"
                                   type="text"
                                   name="price"
                                   value="{$obj->mPost.price}">
                            {if $obj->mErrorMessage.add.price}
                                <span class="help-inline">{$obj->mErrorMessage.add.price}</span>
                            {/if}
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="input-discounted-price">Цена со скидкой:</label>
                        <div class="controls">
                            <input size="8"
                                   class="span2"
                                   id="input-discounted-price"
                                   type="text"
                                   name="discounted_price"
                                   value="{$obj->mPost.discounted_price}">
                        </div>
                    </div>
                    <div class="control-group{if $obj->mErrorMessage.add.availability} error{/if}">
                        <label class="control-label" for="input-availability">Наличие:</label>
                        <div class="controls">
                            <input size="8"
                                   class="span2"
                                   id="input-availability"
                                   type="text"
                                   name="availability"
                                   value="{$obj->mPost.availability}">
                            {if $obj->mErrorMessage.add.availability}
                                <span class="help-inline">{$obj->mErrorMessage.add.availability}</span>
                            {/if}
                        </div>
                    </div>
                    {section name=j loop=$obj->mAttributes}
                    <div class="control-group{if $obj->mErrorMessage.add.attribute_value} error{/if}">
                        <label class="control-label" for="sel-attribute-value">{$obj->mAttributes[j].name}:</label>
                        <div class="controls">
                            <div class="multiselect span2">
                            {section name=k loop=$obj->mAttributes[j].attribute_values}
                                <label class="checkbox control-value" for="check-av-{$obj->mAttributes[j].attribute_values[k].attribute_value_id}">
                                    <input type="checkbox"
                                           id="check-av-{$obj->mAttributes[j].attribute_values[k].attribute_value_id}"
                                           name="attribute_value[]"
                                           value="{$obj->mAttributes[j].attribute_values[k].attribute_value_id}"> {$obj->mAttributes[j].attribute_values[k].name}
                                </label>
                            {/section}
                            </div>
                            {if $obj->mErrorMessage.add.attribute_value}
                                <span class="help-inline">{$obj->mErrorMessage.add.attribute_value}</span>
                            {/if}
                        </div>
                    </div>
                    {/section}
                    <div class="control-group{if $obj->mErrorMessage.add.category || $obj->mErrorMessage.add.subcategory} error{/if}">
                        <label class="control-label" for="sel-category">Каталог:</label>
                        <div class="controls">
                            <div class="multiselect input-xxlarge" id="sel-catalog">
                                {section name=j loop=$obj->mDepartments}
                                    <span class="dep-title {if $smarty.section.j.first}first{/if}"><span>{$obj->mDepartments[j].name}</span></span>
                                    {section name=k loop=$obj->mDepartments[j].categories}
                                        <label class="checkbox cat-categories control-value" for="check-c-{$obj->mDepartments[j].categories[k].category_id}">
                                            <input type="checkbox"
                                                   id="check-c-{$obj->mDepartments[j].categories[k].category_id}"
                                                   name="category[]"
                                                   value="{$obj->mDepartments[j].categories[k].category_id}"> {$obj->mDepartments[j].categories[k].name}
                                        </label>
                                        {section name=n loop=$obj->mDepartments[j].categories[k].subcategories}
                                            <label class="checkbox cat-subcategories control-value{if $smarty.section.n.last} last{/if}" for="check-sc-{$obj->mDepartments[j].categories[k].subcategories[n].subcategory_id}">
                                                <input type="checkbox"
                                                       id="check-sc-{$obj->mDepartments[j].categories[k].subcategories[n].subcategory_id}"
                                                       name="subcategory[]"
                                                       value="{$obj->mDepartments[j].categories[k].subcategories[n].subcategory_id}"> {$obj->mDepartments[j].categories[k].subcategories[n].name}
                                            </label>
                                        {/section}
                                    {/section}
                                {/section}
                            </div>
                            {if $obj->mErrorMessage.add.category || $obj->mErrorMessage.add.subcategory}
                                <span class="help-inline">{if $obj->mErrorMessage.add.category}{$obj->mErrorMessage.add.category}{else}{$obj->mErrorMessage.add.subcategory}{/if}</span>
                            {/if}
                        </div>
                    </div>
                    <div class="control-group{if $obj->mErrorMessage.add.brand} error{/if}">
                        <label class="control-label" for="sel-category">Бренды:</label>
                        <div class="controls">
                            <div class="multiselect input-xxlarge" id="sel-catalog">
                                {section name=j loop=$obj->mCountries}
                                    <span class="dep-title {if $smarty.section.j.first}first{/if}"><span>{$obj->mCountries[j].name}</span></span>
                                    {section name=k loop=$obj->mCountries[j].brands}
                                        <label class="radio cat-categories control-value" for="check-b-{$obj->mCountries[j].brands[k].brand_id}">
                                            <input type="radio"
                                                   id="check-b-{$obj->mCountries[j].brands[k].brand_id}"
                                                   name="brand[]"
                                                   value="{$obj->mCountries[j].brands[k].brand_id}"> {$obj->mCountries[j].brands[k].name}
                                        </label>
                                    {/section}
                                {/section}
                            </div>
                            {if $obj->mErrorMessage.add.brand}
                                <span class="help-inline">{$obj->mErrorMessage.add.brand}</span>
                            {/if}
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="input-alias">Псевдоним:<br/><small>(отображение в URL)</small></label>
                        <div class="controls">
                            <input type="text"
                                   id="input-alias"
                                   class="input-xxlarge"
                                   name="alias"
                                   value="{$obj->mPost.alias}">
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <label class="checkbox" for="check-sale">
                                <input type="checkbox"
                                       id="check-sale"
                                       name="sale"
                                       value=""> Участвует в распродаже
                            </label>
                        </div>
                    </div>
                    <div class="control-group">
                        <div class="controls">
                            <label class="checkbox" for="check-visible">
                                <input type="checkbox"
                                       id="check-visible"
                                       name="visible"
                                       value=""> Не отображать товар на сайте
                            </label>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="input-meta-title">Meta заголовок:</label>
                        <div class="controls">
                            <input type="text"
                                   id="input-meta-title"
                                   class="input-xxlarge"
                                   name="meta_title"
                                   value="{$obj->mPost.meta_title}">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="input-meta-keywords">Meta ключевые слова:</label>
                        <div class="controls">
                            <input type="text"
                                   id="input-meta-keywords"
                                   class="input-xxlarge"
                                   name="meta_keywords"
                                   value="{$obj->mPost.meta_keywords}">
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="input-meta-description">Meta описание:</label>
                        <div class="controls">
                            <textarea id="input-meta-description"
                                      class="input-xxlarge"
                                      rows="3"
                                      name="meta_description">
                                {$obj->mPost.meta_description}
                            </textarea>
                        </div>
                    </div>
                    <div class="g-separator-1"></div>
                    <div class="control-group">
                        <label class="control-label" for="input-file">Эскиз товара:</label>
                        <div class="controls">
                            <div class="add-image thumbnail">
                                <img id="thumbnail" src="http://www.placehold.it/100x100/EFEFEF/AAAAAA&text=no+image" width="100" height="100" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="input-file">Превью товара:</label>
                        <div class="controls">
                            <div class="add-image thumbnail">
                                <img id="preview" src="http://www.placehold.it/200x200/EFEFEF/AAAAAA&text=no+image" width="200" height="200" alt="">
                            </div>
                        </div>
                    </div>
                    <div class="control-group {if $obj->mErrorMessage.add.main} error{/if}">
                        <input type="hidden" name="main" value="">
                        <label class="control-label" for="input-main">Главное изображение:</label>
                        <div class="controls">
                            <span class="btn btn-success fileinput-button">
                                <span>Выберите изображение</span>
                                <input type="file"
                                       id="input-main"
                                       class="fileupload main-image input-xxlarge"
                                       name="main"
                                       typefile="product-main-image">
                            </span>
                            <button class="btn btn-action-delete"
                                    name="delete_image"
                                    title="Удалить изображение"
                                    rel="main">
                                <i class="icon-remove"></i>
                            </button>
                            <div class="progressbar"></div>
                            <div class="clearfix"></div>
                            <div class="add-image thumbnail">
                                <img class="product-image" src="{if $obj->mPost.main}{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mPost.main}{else}http://www.placehold.it/500x100/EFEFEF/AAAAAA&text=no+image{/if}" alt="">
                            </div>
                            {if $obj->mErrorMessage.add.main}
                                <span class="help-inline">{$obj->mErrorMessage.add.main}</span>
                            {/if}
                        </div>
                    </div>
                    {for $i=0 to $obj->mMaxProductImages}
                        <div class="control-group">
                            <input type="hidden" name="big_{$i}" value="">
                            <label class="control-label" for="input-big-{$i}">Изображение ({$i + 1}):</label>
                            <div class="controls">
                                <span class="btn btn-success fileinput-button">
                                    <span>Выберите изображение</span>
                                    <input type="file"
                                           id="input-big-{$i}"
                                           class="fileupload input-xxlarge"
                                           name="big_{$i}"
                                           typefile="product-big-image">
                                </span>
                                <button class="btn btn-action-delete"
                                        name="delete_image"
                                        title="Удалить изображение"
                                        rel="big_{$i}">
                                    <i class="icon-remove"></i>
                                </button>
                                <div class="progressbar"></div>
                                <div class="clearfix"></div>
                                <div class="add-image thumbnail">
                                    <img class="product-image" src="{if $obj->mPost.big[$i]}{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mPost.big[$i]}{else}http://www.placehold.it/500x100/EFEFEF/AAAAAA&text=no+image{/if}" alt="">
                                </div>
                            </div>
                        </div>
                    {/for}
                    <div class="form-actions">
                        <button type="submit"
                                name="submit_add_0"
                                class="btn btn-primary btn-action-add">
                            Добавить
                        </button>
                        <button type="reset"
                                class="btn btn-action-reset">
                            Отмена
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

{include file=$obj->mTemplateFileAjaxUpload}
{include file=$obj->mTemplateFileAjaxDelete}
{include file=$obj->mTemplateEditorShortInit}
{include file=$obj->mTemplateShowDeleteProduct}

{/if}
