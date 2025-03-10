{include file='header.tpl'}
{include file='navbar.tpl'}

<div class="ui breadcrumb">
  {assign i 1}
  {foreach from=$BREADCRUMBS item=breadcrumb}
    {if $i ne 1}<i class="right angle icon divider"></i>{/if}
    <a class="section{if isset($breadcrumb.active)} active{/if}" href="{$breadcrumb.link}">{$breadcrumb.forum_title}</a>
    {assign i $i+1}
  {/foreach}
</div>

<h2 class="ui header">
  {$TOPIC_LABEL} {$TOPIC_TITLE}
  <div class="sub header">
    {$started_by_val="<a href=\"`$TOPIC_AUTHOR_PROFILE`\" style=\"`$TOPIC_AUTHOR_STYLE`\">`$TOPIC_AUTHOR_USERNAME`</a>"}
    {$STARTED_BY|replace:'{x}':$started_by_val}
  </div>
</h2>

{if isset($SESSION_SUCCESS_POST)}
  <div class="ui success icon message">
    <i class="check icon"></i>
    <div class="content">
      <div class="header">Success</div>
      {$SESSION_SUCCESS_POST}
    </div>
  </div>
{/if}

{if isset($SESSION_FAILURE_POST)}
  <div class="ui error icon message">
    <i class="x icon"></i>
    <div class="content">
      <div class="header">Error</div>
      {$SESSION_FAILURE_POST}
    </div>
  </div>
{/if}

{if count($ERRORS)}
  <div class="ui error icon message">
    <i class="x icon"></i>
    <div class="content">
      <div class="header">{$ERROR_TITLE}</div>
      <ul class="list">
        {foreach from=$ERRORS item=error}
          <li>{$error}</li>
        {/foreach}
      </ul>
    </div>
  </div>
{/if}

{$PAGINATION}
      
<div class="res right floated">
  {if isset($UNFOLLOW)}
    <a class="ui small primary button" href="{$UNFOLLOW_URL}">{$UNFOLLOW}</a>
  {elseif isset($FOLLOW)}
    <a class="ui small primary button" href="{$FOLLOW_URL}">{$FOLLOW}</a>
  {/if}
  {if isset($CAN_MODERATE)}
    <div class="ui top right pointing dropdown small primary button">
      <span class="text">{$MOD_ACTIONS}</span>
      <i class="dropdown icon"></i>
      <div class="menu">
        <div class="header">{$MOD_ACTIONS}</div>
        <a class="item" href="{$LOCK_URL}">{$LOCK}</a>
        <a class="item" href="{$MERGE_URL}">{$MERGE}</a>
        <a class="item" data-toggle="modal" data-target="#modal-delete">{$DELETE}</a>
        <a class="item" href="{$MOVE_URL}">{$MOVE}</a>
        <a class="item" href="{$STICK_URL}">{$STICK}</a>
      </div>
    </div>
  {/if}
  <div class="ui top right pointing dropdown small primary button">
    <span class="text">{$SHARE}</span>
      <i class="dropdown icon"></i>
    <div class="menu">
      <div class="header">{$SHARE}</div>
      <a class="item" href="{$SHARE_TWITTER_URL}">{$SHARE_TWITTER}</a>
      <a class="item" href="{$SHARE_FACEBOOK_URL}">{$SHARE_FACEBOOK}</a>
    </div>
  </div>
</div>

{if isset($TOPIC_LOCKED_NOTICE)}
  <div class="ui tiny warning message">
    {$TOPIC_LOCKED_NOTICE}
  </div>
{/if}

{foreach from=$REPLIES item=reply}
  <div class="ui segments" id="topic-post" post-id="{$reply.id}">
    <div class="ui attached padded segment">
      <div class="ui stackable grid">
        <div class="ui row">
          <div class="ui five wide tablet three wide computer column" id="post-sidebar">
            <center>
              <img class="ui small image" src="{$reply.avatar}" alt="{$reply.username}" />
              <h3 class="ui header">
                <a href="{$reply.profile}" style="{$reply.user_style}">{$reply.username}</a>
                {if isset($reply.user_title)}
                  <div class="sub header">{$reply.user_title}</div>
                {/if}
              </h3>
              {foreach from=$reply.user_groups item=group}
                {$group}<br />
              {/foreach}
            </center>
            <div class="ui list">
              <div class="ui divider"></div>
              <div class="item">
                <div class="content">
                  <div class="header">{$reply.user_registered|regex_replace:'/[:].*/':''}</div>
                  <div class="res right floated description">{$reply.user_registered_full}</div>
                </div>
              </div>
              <div class="item">
                <div class="content">
                  <div class="header">{$reply.user_topics_count|regex_replace:'/[0-9]+/':''|capitalize}</div>
                  <div class="res right floated description">{$reply.user_topics_count|regex_replace:'/[^0-9]+/':''}</div>
                </div>
              </div>
              <div class="item">
                <div class="content">
                  <div class="header">{$reply.user_posts_count|regex_replace:'/[0-9]+/':''|capitalize}</div>
                  <div class="res right floated description">{$reply.user_posts_count|regex_replace:'/[^0-9]+/':''}</div>
                </div>
              </div>
            </div>
            {if count($reply.fields)}
              <div class="ui list">
                <div class="ui divider"></div>
                {foreach from=$reply.fields item=field}
                  {if !empty($field.value)}
                    <div class="item">
                      <div class="content">
                        <div class="header">{$field.name}</div>
                        <div class="res right floated description">{$field.value}</div>
                      </div>
                    </div>
                  {/if}
                {/foreach}
              </div>
            {/if}
          </div>
          <div class="ui eleven wide tablet thirteen wide computer column" id="post-content">
            <div class="forum_post">{$reply.content}</div>
            {if (isset($LOGGED_IN_USER) && $reply.user_id !== $USER_ID || count($reply.post_reactions))}
              <div class="ui mini info message" id="reactions">
                {if (isset($LOGGED_IN_USER) && $reply.user_id !== $USER_ID)}
                  <a href="#" data-toggle="popup" data-position="right center">Like</a>
                  <div class="ui wide popup">
                    {if isset($REACTIONS) && count($REACTIONS)}
                      {foreach from=$REACTIONS item=reaction}
                        <form action="{$REACTIONS_URL}" method="post">
                          <input type="hidden" name="token" value="{$TOKEN}">
                          <input type="hidden" name="reaction" value="{$reaction->id}">
                          <input type="hidden" name="post" value="{$reply.id}">
                          <button type="submit" class="ui mini primary icon button">{$reaction->html}</button>
                        </form>
                      {/foreach}
                    {/if}
                  </div>
                {/if}
                {if count($reply.post_reactions)}
                  <div class="right floated" data-toggle="modal" data-target="#modal-reactions-{$reply.id}">
                    {assign i 1}
                    {foreach from=$reply.post_reactions name=reactions item=reaction}
                      {if $i != 1} &nbsp; {/if}
                      {$reaction.html}x{$reaction.count}
                      {assign i $i+1}
                    {/foreach}
                  </div>
                {/if}
              </div>
            {/if}
            {if !empty($reply.signature)}
              <div class="ui divider"></div>
              {$reply.signature}
            {/if}
          </div>
        </div>
      </div>
    </div>
    <div class="ui bottom attached secondary segment" id="post-meta">
      <a href="{$reply.profile}" data-poload="{$USER_INFO_URL}{$reply.user_id}" style="{$reply.user_style}">{$reply.username}</a> &middot; <span data-toggle="tooltip" data-content="{$reply.post_date}">{$reply.post_date_rough}</span>
      {if $reply.edited !== null}&middot; <span data-toggle="tooltip" data-content="{$reply.edited_full}">{$reply.edited}</span>{/if}
      <div class="res right floated">
        {if isset($reply.buttons.spam)}
          <button class="ui mini icon button" data-toggle="modal" data-target="#modal-spam-{$reply.id}" data-tooltip="{$reply.buttons.spam.TEXT}" data-variation="mini" data-inverted=""><i class="flag icon"></i></button>
        {/if}
        {if isset($reply.buttons.edit)}
          <a class="ui mini icon button" href="{$reply.buttons.edit.URL}" data-tooltip="{$reply.buttons.edit.TEXT}" data-variation="mini" data-inverted=""><i class="pencil icon"></i></a>
        {/if}
        {if isset($reply.buttons.delete)}
          <button class="ui mini icon button" data-toggle="modal" data-target="#modal-delete-{$reply.id}" data-tooltip="{$reply.buttons.delete.TEXT}" data-variation="mini" data-inverted=""><i class="trash icon"></i></button>
        {/if}
        {if isset($reply.buttons.report)}
          <button class="ui mini icon button" data-toggle="modal" data-target="#modal-report-{$reply.id}" data-tooltip="{$reply.buttons.report.TEXT}" data-variation="mini" data-inverted=""><i class="exclamation triangle icon"></i></button>
        {/if}
        {if isset($reply.buttons.quote)}
          <button class="ui mini icon button" onclick="quote({$reply.id})" data-tooltip="{$reply.buttons.quote.TEXT}" data-variation="mini" data-inverted=""><i class="quote left icon"></i></button>
        {/if}
      </div>
    </div>
  </div>
{/foreach}

{if isset($TOPIC_LOCKED_NOTICE)}
  <div class="ui tiny warning message">
    {$TOPIC_LOCKED_NOTICE}
  </div>
{/if}

{$PAGINATION}

{if isset($CAN_REPLY)}
  <div class="ui padded segment" id="topic-reply">
    <div class="ui stackable grid">
      <div class="ui row">
        <div class="ui five wide tablet three wide computer column" id="reply-sidebar">
          <center>
            <img class="ui small image" src="{$LOGGED_IN_USER.avatar}"/>
            <h3 class="ui header">
              <a href="{$LOGGED_IN_USER.profile}" style="{$LOGGED_IN_USER.username_style}">{$LOGGED_IN_USER.username}</a>
            </h3>
          </center>
        </div>
        <div class="ui eleven wide tablet thirteen wide computer column" id="reply-content">
          <form class="ui form" action="" method="post">
            {if isset($MARKDOWN)}
              <div class="field">
                <textarea name="content" id="markdown" >{$CONTENT}</textarea>
              </div>
            {else}
              <div class="field">
                <textarea name="content" id="quickreply">{$CONTENT}</textarea>
              </div>
            {/if}
            <input type="hidden" name="token" value="{$TOKEN}">
            <button class="ui primary button" type="submit">{$SUBMIT}</button>
            <button class="ui warning button" id="quoteButton" type="button" onclick="insertQuotes();">{$INSERT_QUOTES}</button>
          </form>
        </div>
      </div>
    </div>
  </div>
{/if}

{foreach from=$REPLIES item=reply}
  {if count($reply.post_reactions)}
    <div class="ui small modal" id="modal-reactions-{$reply.id}">
      <div class="header">
         {$REACTIONS_TEXT}
      </div>
      <div class="content">
        {foreach from=$reply.post_reactions name=reactions item=reaction}
          <strong>{$reaction.html} x {$reaction.count}:</strong>
          <br />
          <div class="ui middle aligned small list">
            {foreach from=$reaction.users item=user}
              <div class="item">
                <img class="ui avatar image" src="{$user.avatar}">
                <div class="content">
                  <a class="header" href="{$user.profile}">{$user.nickname}</a>
                </div>
              </div>
            {/foreach}
          </div>
        {/foreach}
      </div>
    </div>
  {/if}

  {if isset($reply.buttons.report)}
    <div class="ui small modal" id="modal-report-{$reply.id}">
      <div class="header">
         {$reply.buttons.report.TEXT}
      </div>
      <div class="content">
		<form action="{$reply.buttons.report.URL}" method="post" id="form-report-{$reply.id}">
		  <div class="ui form">
		    <div class="field">
              <label for="InputReason">{$reply.buttons.report.REPORT_TEXT}</label>
              <textarea id="InputReason" name="reason"></textarea>
			</div>
            <input type="hidden" name="post" value="{$reply.id}">
            <input type="hidden" name="topic" value="{$TOPIC_ID}">
            <input type="hidden" name="token" value="{$TOKEN}">
		  </div>
		</form>
      </div>
      <div class="actions">
        <a class="ui negative button">{$CANCEL}</a>
        <a class="ui positive button" onclick="$('#form-report-{$reply.id}').submit();">{$reply.buttons.report.TEXT}</a>
      </div>
    </div>
  {/if}
  {if isset($CAN_MODERATE)}
    <div class="ui small modal" id="modal-spam-{$reply.id}">
      <div class="header">
         {$MARK_AS_SPAM}
      </div>
      <div class="content">
        {$CONFIRM_SPAM_POST}
		<form action="{$reply.buttons.spam.URL}" method="post" id="form-spam-{$reply.id}">
          <input type="hidden" name="post" value="{$reply.id}">
          <input type="hidden" name="token" value="{$TOKEN}">
		</form>
      </div>
      <div class="actions">
        <a class="ui negative button">{$CANCEL}</a>
        <a class="ui positive button" onclick="$('#form-spam-{$reply.id}').submit();">{$MARK_AS_SPAM}</a>
      </div>
    </div>
    <div class="ui small modal" id="modal-delete-{$reply.id}">
      <div class="header">
         {$CONFIRM_DELETE_SHORT}
      </div>
      <div class="content">
        {$CONFIRM_DELETE_POST}
		<form action="{$reply.buttons.delete.URL}" method="post" id="form-delete-{$reply.id}">
          <input type="hidden" name="tid" value="{$TOPIC_ID}">
          <input type="hidden" name="number" value="{$reply.buttons.delete.NUMBER}">
          <input type="hidden" name="pid" value="{$reply.id}">
          <input type="hidden" name="token" value="{$TOKEN}">
		</form>
      </div>
      <div class="actions">
        <a class="ui negative button">{$CANCEL}</a>
        <a class="ui positive button" onclick="$('#form-delete-{$reply.id}').submit();">{$reply.buttons.delete.TEXT}</a>
      </div>
    </div>
  {/if}
{/foreach}

{if isset($CAN_MODERATE)}
  <div class="ui small modal" id="modal-delete">
    <div class="header">
      {$CONFIRM_DELETE_SHORT}
    </div>
    <div class="content">
      {$CONFIRM_DELETE}
    </div>
    <div class="actions">
      <a class="ui negative button">{$CANCEL}</a>
      <a class="ui positive button" href="{$DELETE_URL}">{$DELETE}</a>
    </div>
  </div>
{/if}

{include file='footer.tpl'}