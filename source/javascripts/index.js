var $ = require("jquery");
global.jQuery = $;

import modernizr from 'modernizr';
import Popper from 'popper.js';

$(document).ready(function(){
  // mobile nav toggler
  $(".js-nav-toggler").click(function(e){
    e.preventDefault();
    $(".canvas").toggleClass("is-shifted");
  });

  var tooltips = [].slice.call(document.querySelectorAll('.js-tooltip'));

  tooltips.forEach(function(tooltip) {
    var popup = tooltip.querySelector('.js-tooltip-content');
    var ref = tooltip.querySelector('.js-tooltip-button');

    ref.onmouseover = function(e) {
      popup.classList.remove('hidden');
    }
    ref.onmouseout = function(e) {
      popup.classList.add ('hidden');
    }

    var popper = new Popper(tooltip,popup,{
      placement: 'right',
      modifiers: {
        flip: {
          behavior: ['left', 'right', 'top','bottom']
        },
        offset: {
          enabled: true,
          offset: '0,10'
        }
      }
    });
  })
});
