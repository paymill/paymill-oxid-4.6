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
