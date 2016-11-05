function getNaturalWidth(obj, text){
    var clone = obj.clone();
    clone.css("visibility","hidden").css('width', 'auto').html(text);
    $('body').append(clone);
    var width = clone.css('width');
    clone.remove();
    return width;
}

function fadeOut(element) {
  $(element).transition({ opacity: 0 });
  setTimeout(function () {
      $(element).css('visibility', 'hidden');
  }, 300);
}

function fadeIn(element) {
  $(element)
    .css('visibility', 'visible')
    .transition({ opacity: 1 });
}
// $('p').hyphenate('en-gb');

var editor = ace.edit("editor");
editor.setTheme("ace/theme/chrome");
editor.getSession().setMode("ace/mode/latex");
editor.setOptions({
  fontSize: 16,
  maxLines: 20,
  minLines: 5
});
editor.on('change', function() {
  $('#compile')
    .attr('disabled', false)
    .html("Compile!");
});

var logger = ace.edit("logger");
// logger.setTheme("ace/theme/chrome");
// logger.getSession().setMode("ace/mode/latex");
logger.setOptions({
  readOnly: true,
  showGutter: false,
  fontSize: 16,
  maxLines: Infinity,
  // minLines: 2
});

$('#compile').click(function() {

  fadeOut('#diagram-wrapper');
  fadeOut('#logger-wrapper');
  fadeIn('#loader-wrapper');

  $('#display')
      .transition({ 'min-height': $('#loader-wrapper').css('height') }, 150 );

  $('#compile')
    .attr('disabled', true)
    .html("Compiling&hellip;");

  var longWaitTimerId = setTimeout(function () {
    $('#loader-message')
      .html("Server asleep: waking up the poor thing.");
  }, 2400);

  $('#loader-message').html('');

  $.ajax({

    method: 'POST',
    url: 'https://texrhobot.herokuapp.com/crank',
    // url: 'http://0.0.0.0:5000/crank',
    data: {
      "document": editor.getValue(),
      'template': 'latex-minimal',
      'format': 'kodi-livedemo'
    }

  }).done(function(data) {

    fadeOut('#loader-wrapper');

    $('#compile').html("Tweak the code!");
    clearTimeout(longWaitTimerId);

    var svg = $(data).find("svg");

    var exHeight = parseFloat(svg.attr('height'))/4.3+"ex";
    var exWidth  = parseFloat(svg.attr('width' ))/4.3+"ex";
    svg.attr('height', exHeight);
    svg.attr('width',  exWidth );
    $('#display')
      .transition({ height: exHeight }, 150 );

    $('#diagram-wrapper').html(svg);
    fadeIn('#diagram-wrapper');

  }).fail(function(jqXHR, textStatus, errorThrown) {

    fadeOut('#loader-wrapper');
    $('#compile').html("You goofed up.");

    fadeIn('#logger-wrapper');
    logger.setValue(jqXHR.responseText, -1);

    /* TODO: this is ridiculous, dammit... */
    setTimeout(function () {
      var h = $('#logger-wrapper').css('height');
      $('#display')
        .transition({ height: h }, 140 );
    }, 10);

  });

});
