var $ = require("jquery");
global.jQuery = $;

import modernizr from 'modernizr';

$(document).ready(function(){
  // mobile nav toggler
  $(".js-nav-toggler").click(function(e){
    e.preventDefault();
    $(".canvas").toggleClass("is-shifted");
  });
});
