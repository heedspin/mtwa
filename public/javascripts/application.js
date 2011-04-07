// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
  $('.wymeditor').wymeditor({
      skin: 'timpact',
		stylesheet: '/stylesheets/wymeditor.css'
  });


	$(".toggle_button").bind('click', function(event) {
	  event.preventDefault();
	  $(this).closest("div.openable").toggleClass("open");
	});

});

