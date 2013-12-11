<html>
    <head>
        <title>[{ oxmultilang ident="GENERAL_ADMIN_TITLE" }]</title>
    </head>
    <div id=liste>
        <ul>
            <li>
                <form name="paymill_register_hook" id="notification" action="[{$oViewConf->getSelfLink()}]" method="post">
                    <label for="hook_url">[{ oxmultilang ident="PAYMILL_HOOK_URL" }]</label>
                    <input type="text" value="[{$hookUrl}]" name="hook_url"/>
                    <input type="submit" value='[{ oxmultilang ident="PAYMILL_HOOK_URL_REGISTER" }]'>
                    <input type="hidden" name="cl" value="[{$oViewConf->getActiveClassName()}]">
                    <input type="hidden" name="fnc" value="registerHookPoint">
                    [{$oViewConf->getHiddenSid()}]
                </form>
            </li>
        </ul>
    </div>
    [{include file="bottomnaviitem.tpl"}]
</html>