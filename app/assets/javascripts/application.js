// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require handlebars
//= require 'vendor/datejs'
//= require ember
//= require ember-data
//= require_self
//= require coach_me
App = Ember.Application.create();
//= require_tree .

//= require bootstrap-datepicker/core
//= require underscore
//= require ember

$(window).ready(function(){
  $(document).on("focus", "[data-behaviour~='datepicker']", function(e){
    $(this).datepicker({"format": "yyyy.mm.dd", "weekStart": 1, "autoclose": true});
  });

  // bootstrap popover initialization
  $('[rel=popover]').popover();
});
