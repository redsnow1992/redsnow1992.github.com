---
title: javascript日用代码集合（一）
date: 2015-05-11 22:24
updated: 2015-05-11 22:24
categories: programming
tags: javascript
---
## 获取url参数
```javascript
function get_url_param(name){
   var reg = new RegExp("(^|&)" + name + "=([^&*]+)(&|$)") ;
   var r = window.location.search.substr(1).match(reg) ;
   if (r != null){
     return unescape(r[2]) ;
   }
   else{
     return null ;
   }
 }
```
## 阻止菜单提交
```javascript
$("form").submit(function(e){
    e.preventDefault() ;
});
window.location.reload() ; // 一般还要再将页面载入一次，比如当你disable了一些控件。
```
## 发送ajax请求
```javascript
$.ajax({
   url: "",
   type: "post",
   data: {},
   success: function(html) {},
   error: function(){}
}) ;
ajax是一个函数，参数是一个json
```

## ajax上传文件（使用[FormData](https://developer.mozilla.org/en-US/docs/Web/Guide/Using_FormData_Objects)）
```javascript
var fd = new FormData($("#form1")[0]) ;
fd.append('attachment1_path', $("[name=attachment1_path]")[0].files[0]) ;

$.ajax({
  data: fd, 
  processData: false,  //  必须设置这两个参数
  contentType: false, //
}) ;

ajax提交多个表单，并且上传文件时：
var fd = new FormData($("#form3")[0]) ;
append_formdata(fd, "#form1") ;
append_formdata(fd, "#form2") ;
fd.append('attachment1_path', $("[name=attachment1_path]")[0].files[0]) ;

function append_formdata(fd, selector){
  var form = $(selector).serializeArray() ;
  for(var i = 0 ; i < form.length ; i++){
    fd.append(form[i].name, form[i].value) ;
  }
  return fd ;
}
```
## eval
```javascript
function check(){
  var value = arguments[0] ;
  for(var i = 1 ; i < arguments.length ; i++){
    if (eval(eval(arguments[i])(value)) == false){
      return false ;
    }
  }
  return true ;
}
check(unit_price, "non_empty", "number", "positive")
function non_empty(){}
function number() {}
function positive() {}
```

## 替换页面元素
```javascript
var node = $("#element")[0] ;
var p = node.parentNode ;
var new_node = document.createTextNode("替换元素") ;
p.replaceChild(new_node, node) ;
```