---
title: javascript日用代码集合（二）
date: 2015-06-09 19:21
categories: programming
tags: javascript
---
# Javascript自动补全
1. 在html上设置补全信息显示的地方（place）
2. 设置place的样式
3. js发送ajax请求，获取数据，置空并填充place，一般为一个列表链结（list）
4. 点击list中的某项，隐藏place，填充真正的field
 
```erb
<div class="control-group">
  <%= label_tag :content, "渠道编号", class: "control-label" %>
  <div class="controls">
    <%= text_field_tag(:channel, params[:channel] || @partner.channel, class: "input-medium", onkeyup: "show_channel_hint(this.value)") %>
  </div>
  <%= hidden_field_tag(:partner_id, params[:partner_id] || @partner.id) %>
  
  <span id="msg_channel" style="color:red;"></span>
  <div id="search_channel">
  </div>
</div>
```

```css
 #search_channel{
   display:none;
   position: relative;
   margin-top: -1px;
   width: 162px;
   padding-top: 1px;
   border: 1px solid #369;
   border-top: 0 none;
   border-radius: 4px;
   box-shadow: inset 0 0 2px #999;
   overflow: hidden;
   left: 20px;
 }
 #search_channel a { 
   display:block; 
   color:#f00;
   height:24px;
   line-height:24px;
   text-decoration:none; 
   padding:0 4px;
 }
```

```javascript
function show_channel_hint(text){
  $.ajax({
    url: "/admin/payment_template/search_channel",
    type: 'post',
    data: {text: text},
    success: function(data){
      $("#search_channel").css("display", "none") ; // 隐藏
      $("#search_channel").empty() ;                // 置空
      if(data['channels_info'].length > 0){
        for(var i = 0 ; i < data['channels_info'].length ; i++){
          $("#search_channel").append("<a href='javascript:void(0);' channel='" + data["channels_info"][i][0] + "' partner_id='" + data["channels_info"][i][1]+ "' onclick='search_partner(this)'>" + data["channels_info"][i][0] + "</a>") ;
        }
        $("#search_channel").css("display", "block") ;  // 显示
      }
      if($("#search_channel").css("display") == "none"){
        $("#msg_channel").html("渠道编号不存在，请先新建渠道") ;
      }
      else{
        $("#msg_channel").html("") ;
      }
    },
    error: function(){
      alert("请求出错，请稍后再试！") ;
      return false ;
    }
  }) ;
}
```

```javascript
function search_partner(a){
  var channel = $(a).attr('channel') ;
  var partner_id = $(a).attr('partner_id') ;
  $.ajax({
    url: '/admin/payment_template/search_partner',
    type: 'post',
    data: {partner_id: partner_id},
    success: function(data){
      $("#channel").val(channel) ;
      $("#search_channel").css("display", "none") ;
      $("#name").val(data['name']) ;
      $("#partner_id").val(data['partner_id']) ;
      return true ;
    },
    error: function(){
      alert("请求出错，请稍后再试！") ;
      return false ;
    }     
  }) ;
}
```
# [jquery have event `handler` in onclick function](https://forum.jquery.com/topic/how-to-pass-event-target-to-a-function)
```javascript
onclick="dosomething.call(this, event, other_args)"

function dosomething(event, other_args){
  ... // use event
}
```
