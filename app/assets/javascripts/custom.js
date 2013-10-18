$(document).on("ajaxStart", function(){
  $("img").css("display","block");
  $("#content-page").css("display","none");
  $("footer").css("display","none");
});

$(document).on("ajaxComplete", function(){
  $("img").css("display","none");
  $("#content-page").css("display","block");
  $("footer").css("display","block");
});
