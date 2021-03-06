// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery
//= require jquery-ui
//= require tag-it
//= require_tree .
//= require popper
//= require bootstrap-sprockets

$(function() {
  $(document).on('turbolinks:load', () => {
    $("#user_postal_code").jpostal({
      postcode: ["#user_postal_code"],
      address: {
        "#user_prefecture_code": "%3",
        "#user_city": "%4%5",
        "#user_street": "%6",
        "#user_building": "%7"
      },
    });
  });
});

$(function() {
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('.img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }
  
  $(document).on('turbolinks:load', () => {
    $(".img").change(function(){
      readURL(this);
    });
  });
});

$(function() {
  $(document).on('turbolinks:load', () => {
    $('#tags').tagit();
  });
})

$(function(){
  $(document).on('turbolinks:load', () => {
    $(".key-visual__title h1 span").addClass("fadein");
  });

  $(window).scroll(function () { 
    $(".key-visual__title h1 span").each(function(){
      const scroll = $(window).scrollTop();
      if(scroll !== 0) {
        $(".key-visual__title h1 span").removeClass("fadein");
      } else {
        $(".key-visual__title h1 span").addClass("fadein");
      }
    });
  });

  $(window).scroll(function (){
    $("#about h2 span").each(function(){
      var targetElement = $(this).offset().top;
      var scroll = $(window).scrollTop();
      var windowHeight = $(window).height();
      if (scroll > targetElement - windowHeight + 200){
        $("#about h2 span").addClass("fadein_sec");
      }
    });
  });

  $(window).scroll(function (){
    $(".top-posts h2 span").each(function(){
      var targetElement = $(this).offset().top;
      var scroll = $(window).scrollTop();
      var windowHeight = $(window).height();
      if (scroll > targetElement - windowHeight + 200){
        $(".top-posts h2 span").addClass("fadein_sec");
      }
    });
  });

  $(window).scroll(function (){
    $(".top-recipes h2 span").each(function(){
      var targetElement = $(this).offset().top;
      var scroll = $(window).scrollTop();
      var windowHeight = $(window).height();
      if (scroll > targetElement - windowHeight + 200){
        $(".top-recipes h2 span").addClass("fadein_sec");
      }
    });
  });
});
