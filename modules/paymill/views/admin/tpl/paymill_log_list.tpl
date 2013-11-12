[{include file="headitem.tpl" title="GENERAL_ADMIN_TITLE"}]
<div style="margin-bottom: 10px;">
    <form action="" method="POST">
        Page:
        [{assign var=b value="1"}]
        [{section name=foo start=$a loop=$pageCount step=1}]
            [{if $page == $b}]
                <span style="font-weight: bold;">[{$b}]</span>
            [{else}]
                <span style="font-weight: bold;"><a href="[{$listUrl}]&seite=[{$b}]" target="list">[{$b}]</a></span>
            [{/if}]
            [{assign var=b value=$b+1}]
        [{/section}]
        <span style="float: right;">
            <input value="" name="search_key"/>
            <input type="submit" value="Search" name="submit"/>
        </span>
    </form>
</div>
<table cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr>
        <td class="listheader">OXID</td>
        <td class="listheader">IDENTIFIER</td>
        <td class="listheader">DEBUG</td>
        <td class="listheader">MESSAGE</td>
        <td class="listheader">DATE</td>
    </tr>
    [{assign var=oddclass value="2"}]
    [{assign var=counter value="0"}]
    [{foreach from=$list item=log}]
    [{if $oddclass == 2}]
    [{assign var=oddclass value=""}]
    [{else}]
    [{assign var=oddclass value="2"}]
    [{/if}]
    <tr>
        <td class="listitem[{$oddclass}]">[{$log->paymill_logging__oxid->rawValue}]</td>
        <td class="listitem[{$oddclass}]">[{$log->paymill_logging__identifier->rawValue}]</td>
        <td class="listitem[{$oddclass}]">
            [{if $log->paymill_logging__debug->rawValue|count_characters < 300}]
            <pre>[{$log->paymill_logging__debug->rawValue}]</pre>
            [{else}]
            <a href="[{$editUrl}]&entryId=[{$log->paymill_logging__oxid->rawValue}]" target="edit">More..</a>
            [{/if}]
        </td>
        <td class="listitem[{$oddclass}]">[{$log->paymill_logging__message->rawValue}]</td>
        <td class="listitem[{$oddclass}]">[{$log->paymill_logging__date->rawValue}]</td>
    </tr>
    [{assign var="counter" value=$counter+1}]
    [{/foreach}]
</table>
<div style="margin-top: 5px;">
    <form action="" method="POST">
        Page:
        [{assign var=b value="1"}]
        [{section name=foo start=$a loop=$pageCount step=1}]
            [{if $page == $b}]
                <span style="font-weight: bold;">[{$b}]</span>
            [{else}]
                <span style="font-weight: bold;"><a href="[{$listUrl}]&seite=[{$b}]" target="list">[{$b}]</a></span>
            [{/if}]
            [{assign var=b value=$b+1}]
        [{/section}]
        <span style="float: right;">
            <input value="" name="search_key"/>
            <input type="submit" value="Search" name="submit"/>
        </span>
    </form>
</div>
[{include file="pagetabsnippet.tpl"}]