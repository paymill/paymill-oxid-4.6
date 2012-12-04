[{include file="headitem.tpl" title="PAYMILL_TITLE"|oxmultilangassign}]

<div id=liste>

    <form name="myedit" id="myedit" action="[{$oViewConf->getSelfLink()}]" method="post">
        [{$oViewConf->getHiddenSid()}]
        <input type="hidden" name="cl" value="[{$oViewConf->getActiveClassName()}]">
        <input type="hidden" name="fnc" value="save">
        <input type="hidden" name="oxid" value="[{$oxid}]">
        <input type="hidden" name="editval[oxshops__oxid]" value="[{$oxid}]">
        <table cellspacing="0" cellpadding="0" border="0" style="width:100%;height:100%;">
            <tr>
                <td valign="top" class="edittext" style="padding:10px;">
                    <table cellspacing="0" cellpadding="5" border="0" class="edittext" style="text-align: left;">
                        
                        <tr>
                            <td colspan="2">
                                [{ oxmultilang ident="PAYMILL_ACCOUNT_HEADER" }] <a href="http://www.paymill.de" target="_blank">Paymill</a>
                            </td>
                        </tr>
                        
                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_API_URL" }]</td>
                            <td valign="top" class="edittext">
                                <input type=text class="editinput" style="width:410px" name=confstrs[paymill_api_url] value="[{if $confstrs.paymill_api_url == ""}]https://api.paymill.de/v2/[{else}][{$confstrs.paymill_api_url}][{/if}]" />
                            </td>
                        </tr>
                        
                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_BRIDGE_URL" }]</td>
                            <td valign="top" class="edittext">
                                <input type=text class="editinput" style="width:410px" name=confstrs[paymill_bridge_url] value="[{if $confstrs.paymill_bridge_url == ""}]https://bridge.paymill.de/[{else}][{$confstrs.paymill_bridge_url}][{/if}]" />
                            </td>
                        </tr>
                        
                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_LIB_VERSION" }]</td>
                            <td valign="top" class="edittext">
                                <select name="confstrs[paymill_lib_version]">
                                    <option value="v2"[{if $confstrs.paymill_lib_version == "v2"}] selected="selected"[{/if}]>V2</option>
                                </select>
                            </td>
                        </tr>

                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_CC_ACTIVE" }]</td>
                            <td valign="top" class="edittext">
                                <select name="confstrs[paymill_cc_active]">
                                    <option value="yes"[{if $confstrs.paymill_cc_active == "yes" || $confstrs.paymill_cc_active == ""}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_YES" }]</option>
                                    <option value="no"[{if $confstrs.paymill_cc_active == "no"}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_NO" }]</option>
                                </select>
                            </td>
                        </tr>

                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_ELV_ACTIVE" }]</td>
                            <td valign="top" class="edittext">
                                <select name="confstrs[paymill_elv_active]">
                                    <option value="yes"[{if $confstrs.paymill_elv_active == "yes" || $confstrs.paymill_elv_active == ""}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_YES" }]</option>
                                    <option value="no"[{if $confstrs.paymill_elv_active == "no"}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_NO" }]</option>
                                </select>
                            </td>
                        </tr>
                            
                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_SHOW_LABEL" }]</td>
                            <td valign="top" class="edittext">
                                <select name="confstrs[paymill_show_label]">
                                    <option value="yes"[{if $confstrs.paymill_show_label == "yes" || $confstrs.paymill_show_label == ""}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_YES" }]</option>
                                    <option value="no"[{if $confstrs.paymill_show_label == "no"}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_NO" }]</option>
                                </select>
                            </td>
                        </tr>
                        
                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_PUBLIC_KEY" }]</td>
                            <td valign="top" class="edittext">
                                <input type=text class="editinput" style="width:410px" name=confstrs[paymill_public_key] value="[{$confstrs.paymill_public_key}]" />
                            </td>
                        </tr>

                        <tr>
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_PRIVATE_KEY" }]</td>
                            <td valign="top" class="edittext">
                                <input type=text class="editinput" style="width:410px" name=confstrs[paymill_private_key] value="[{$confstrs.paymill_private_key}]" />
                            </td>
                        </tr>

                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_LOGGING" }]</td>
                            <td valign="top" class="edittext">
                                <input type=text class="editinput" style="width:410px" name=confstrs[paymill_logging] value="[{if $confstrs.paymill_logging == ""}]0[{else}][{$confstrs.paymill_logging}][{/if}]" />
                            </td>
                        </tr>

                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap="">[{ oxmultilang ident="PAYMILL_DEBUG_MODE" }]</td>
                            <td valign="top" class="edittext">
                                <select name="confstrs[paymill_debug_mode]">
                                    <option value="yes"[{if $confstrs.paymill_debug_mode == "yes"}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_YES" }]</option>
                                    <option value="no"[{if $confstrs.paymill_debug_mode == "no" || $confstrs.paymill_debug_mode == ""}] selected="selected"[{/if}]>[{ oxmultilang ident="PAYMILL_NO" }]</option>
                                </select>
                            </td>
                        </tr>
                        
                        <tr> 
                            <td valign="top" class="edittext" width="250" nowrap=""></td>
                            <td valign="top" class="edittext">
                                <input type="submit" name="save" value="[{ oxmultilang ident="PAYMILL_UPDATE_SETUP" }]">

                                [{if $oView->hasRegisteredTemplateBlocks()}]
                                <input type="button" value="[{ oxmultilang ident="PAYMILL_UNINSTALL_TPL_BLOCKS" }]" onclick="window.location.href='[{$oViewConf->getSelfLink()}]cl=paymill_configuration&fnc=uninstallTemplateBlocks';" />
                                [{else}]
                                <input type="button" value="[{ oxmultilang ident="PAYMILL_INSTALL_TPL_BLOCKS" }]" onclick="window.location.href='[{$oViewConf->getSelfLink()}]cl=paymill_configuration&fnc=installTemplateBlocks';" />
                                [{/if}]    

                                <input type="button" value="[{ oxmultilang ident="PAYMILL_INSTALL_PAYMENTS" }]" onclick="window.location.href='[{$oViewConf->getSelfLink()}]cl=paymill_configuration&fnc=installPayments';" />          
                            </td>
                        </tr>

                    </table>
                </td>
            </tr>
        </table>
    </form>
    [{include file="pagenavisnippet.tpl"}]
</div>
[{include file="pagetabsnippet.tpl"}]

[{include file="bottomnaviitem.tpl"}]

[{include file="bottomitem.tpl"}]
