<!-- информация о продукте на сайте -->

{* front_products.tpl *}
{load_presentation_object filename="FrontProduct" assign="obj"}

<article class="blue-comb">
    <div class="news-stock-block">
        <div class="product_block">
            <div class="left_content">
                {include file=$obj->mTemplateLeftMenu}
            </div>
            <div class="right_content">
                <div class="list_nav">
                    {if $obj->mCountry.name}
                    <ul>
                        <li class="first"><a href="/">Главная</a></li>
                        {if $obj->mDepartment.name}
                        <li class="for_last_a">
                            <a href="{$obj->mDepartment.url}">{if $obj->mDepartment.name}{$obj->mDepartment.name}{/if}</a>
                        </li>
                        {/if}
                        {if $obj->mCountry.name}
                        <li>
                            <a href="{$obj->mCountry.url}">{if $obj->mCountry.name}{$obj->mCountry.name}{/if}</a>
                        </li>
                        {/if}
                        {if $obj->mBrand.name}
                        <li class="last">
                            <a href="{$obj->mBrand.url}">{if $obj->mBrand.name}{$obj->mBrand.name}{/if}</a>
                        </li>
                        {/if}
                    </ul>
                    <div class="clearfix"></div>
                    {/if}
                    {if $obj->mCategory.name}
                    <ul>
                        <li class="first"><a href="/">Главная</a></li>
                        {if $obj->mDepartment.name}
                        <li class="for_last_a">
                            <a href="{$obj->mDepartment.url}">{if $obj->mDepartment.name}{$obj->mDepartment.name}{/if}</a>
                        </li>
                        {/if}
                        {if $obj->mCategory.name}
                        <li>
                            <a href="{$obj->mCategory.url}">{if $obj->mCategory.name}{$obj->mCategory.name}{/if}</a>
                        </li>
                        {/if}
                        {if $obj->mSubcategory.name}
                        <li class="last">
                            <a href="{$obj->mSubcategory.url}">{if $obj->mSubcategory.name}{$obj->mSubcategory.name}{/if}</a>
                        </li>
                        {/if}
                        {*{if $obj->mProduct.name}
                        <li class="last">
                        <a href="#">
                         {if $obj->mProduct.name}{$obj->mProduct.name}{/if}
                        </a>
                        </li>
                         {/if}*}
                    </ul>
                    {/if}
                </div>
                <div class="clearfix"></div>
                <div class="list_content" id="product-form" pid="{$obj->mProduct.product_id}">
                    <div class="left_good_content">
                        <div class="thumbnail">{*top_left_good_content*}
                            {if $obj->mProduct.images.main}
                            <a target="_blank" href="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mProduct.images.main[0]}"><img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mProduct.images.main[0]}" height="465" alt="" /></a>
                            {else}
                            <a target="_blank" href="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsPreviewResourcesDir}{$obj->mProduct.images.preview[0]}"><img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsPreviewResourcesDir}{$obj->mProduct.images.preview[0]}" height="465" alt="" /></a>
                            {/if}
                        </div>
                        {if $obj->mProduct.images.big}{/if}
                        <div class="bot_left_good_content">
                            {section name=i loop=$obj->mProduct.images.big}
                            <div class="thumbnail bot_left_good_content_box {if ($smarty.section.i.iteration > 1 && $smarty.section.i.iteration % 3 == 0) || $smarty.section.i.last}last{/if}">
                                <a target="_blank" href="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mProduct.images.big[i]}"><img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsResourcesDir}{$obj->mProduct.images.big[i]}"  alt="" /></a>
                            </div>
                            {/section}
                            {*<div class="thumbnail bot_left_good_content_box">
                                <img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsThumbnailsResourcesDir}{$obj->mProduct.images.thumbnail}" alt="" />
                            </div>
                            <div class="thumbnail bot_left_good_content_box">
                                <img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsThumbnailsResourcesDir}{$obj->mProduct.images.thumbnail}" alt="" />
                            </div>
                            <div class="thumbnail bot_left_good_content_box last">
                                <img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsThumbnailsResourcesDir}{$obj->mProduct.images.thumbnail}" alt="" />
                            </div>
                            <div class="thumbnail bot_left_good_content_box">
                                <img src="{$obj->mLinkToSiteResourcesDir}{$obj->mLinkToItemsThumbnailsResourcesDir}{$obj->mProduct.images.thumbnail}" alt="" />
                            </div>*}
                        </div>

                    </div>
                    <div class="right_good_content">
                        <h3>{$obj->mProduct.name}</h3>
                        <p>Артикул:<span>{$obj->mProduct.article}</span></p>
                        {*<p>Наличие:<span class="availability" id="product-availability">{if $obj->mProduct.availability}{$obj->mProduct.availability}{else}Нет в наличии{/if}</span></p>*}
                        <div class="description">
                            Описание:
                            <div>{$obj->mProduct.description}</div>
                        </div>
                        <div class="product-attributes well well-small">
                            {section name=i loop=$obj->mProduct.attributes}
                             <p>{$obj->mProduct.attributes[i].attribute_name}:</p>
                                {section name=j loop=$obj->mProduct.attributes[i].attribute_values}
                                    <span class="attr-label"><input type="radio" value="{$obj->mProduct.attributes[i].attribute_values[j].attribute_value_id}" name="attribute_value_id">{$obj->mProduct.attributes[i].attribute_values[j].attribute_value_name}</span>
                                {/section}
                            {/section}
                        </div>
                        <p>Цена:<span class="price">{if $obj->mProduct.discounted_price > 0}{$obj->mProduct.discounted_price} грн<br><span>{$obj->mProduct.price} грн</span>{else}{$obj->mProduct.price}{/if}</span></p>
                        <div class="button-in-basket">
                            <select name="count_product" class="span1">
                                {if $obj->mProduct.availability}
                                    {section name=availability loop=$obj->mProduct.availability}
                                        <option val="{$smarty.section.availability.index+1}">{$smarty.section.availability.index+1}</option>
                                    {/section}
                                {else}
                                    <option val="0">Нет в наличии</option>
                                {/if}
                            </select>
                            {*<input name="count_product" value="1" maxlength="3">*}
                            <a class="add-in-basket" href="#"></a>
                        </div>
                    </div>
                </div>
            </div>
            <div class="clearfix"></div>
        </div>
    </div>
</article>


{include file=$obj->mTemplateControlProductInBasket}
