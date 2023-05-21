(function ($) {
var th = null, cf = null, toast = function(m,o){
// fix option type
o = $.extend({ duration: 5000, sticky: false, 'type': ''}, o);
typeof o.duration === 'number' || (o.duration = 5000);
typeof o.sticky === 'boolean' || (o.sticky = false);
typeof o.type === 'string' || (o.type = '');
   // create host on first call
$('.toast').remove();
th = null;
if (!th) {
   // get/fix config
   cf = toast.config;
  
th = $('<ul id="' + o.type + '"></ul>').addClass('toast').appendTo(document.body).hide();
}
$('.toast').attr('id', o.type)
// create toast
var ti = $('<li></li>').hide().html(m).appendTo(th), cb = $('<button>&times;</button>').addClass('close').prependTo(ti), to = null;
   // setup close button
th.click(function () {
   clearTimeout(to);
   ti.animate({ height: 0, opacity: 0 }, 'fast', function () {
       ti.remove();
       th.children().length || th.removeClass('active').hide();
   });
});
cb.click(function(){
clearTimeout(to);
ti.animate({ height: 0, opacity: 0}, 'fast', function(){
ti.remove();
th.children().length || th.removeClass('active').hide();
});
});
cf.closeForStickyOnly && !o.sticky && cb.hide();
// add type class
o.type !== '' && ti.addClass(o.type);
// show host if necessary
!th.hasClass('active') && th.addClass('active').show();
// setup timeout unless sticky
!o.sticky && o.duration > 0 && (to = setTimeout(function(){ cb.click(); }, o.duration));
// show toast
ti.fadeIn('normal');
};
toast.config = { width: 350, align: 'center', closeForStickyOnly: true };
$.extend({ toast: toast });
})(jQuery);

function AlertLogy(mensaje,Tipo,titulo) {
    var sticky = true;
    var duration = Math.floor(Math.random() * 4001) + 1000;
    var type = 'warn';
    Tipo = Tipo.toLowerCase();
    switch (Tipo) {
        case 'verde':
            sticky = false;
            type = 'success'
            break;
        case 'rojo':
            type = 'danger';
            break;
        case 'amarillo':
            type = 'warn';
            break;
        case 'azul':
            type = 'info';
            break;
        default:
    }
    var options = {
        duration: duration,
        sticky: sticky,
        type: type
    };
    var message = '<h4>' + titulo + '</h4>' + ' ' + '<span style="margin-left:10px">' + mensaje + '</span>';;
    //Lanza el mensaje
    $.toast(message, options);
}
window.alert = function (message, tipo, titulo) {
    tipo = tipo ? tipo : 'warn';
    titulo = titulo ? titulo : 'LOGYTECH ';
    AlertLogy(message,tipo,titulo);
};