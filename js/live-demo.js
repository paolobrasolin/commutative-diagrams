function getNaturalWidth(obj, text){
    var clone = obj.clone();
    clone.css("visibility","hidden").css('width', 'auto').html(text);
    $('body').append(clone);
    var width = clone.css('width');
    clone.remove();
    return width;
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

  $('#diagram-wrapper').transition({ opacity: 0 });
  $('#logger-wrapper').transition({ opacity: 0 });
  $('#loader-wrapper').transition({ opacity: 1 });

  $('#display')
      .transition({ height: $('#loader-wrapper').css('height') }, 150 );

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
    // url: 'http://0.0.0.0:9292/crank',
    data: {
      "document": editor.getValue(),
      'template': 'latex-minimal',
      'format': 'kodi'
    }

  }).done(function(data) {

    $('#loader-wrapper').transition({ opacity: 0 });
    $('#compile').html("Tweak the code!");
    clearTimeout(longWaitTimerId);

    var svg = $(data).find("svg");

    var exHeight = parseFloat(svg.attr('height'))/4.3+"ex";
    var exWidth  = parseFloat(svg.attr('width' ))/4.3+"ex";
    svg.attr('height', exHeight);
    svg.attr('width',  exWidth );
    $('#display')
      .transition({ height: exHeight }, 150 );

    $('#diagram-wrapper')
      .html(svg)
      .transition({ opacity: 1 },  150, 'snap' );

  }).fail(function(jqXHR, textStatus, errorThrown) {

    $('#loader-wrapper').transition({ opacity: 0 });
    $('#compile').html("You goofed up.");

    logger.setValue(jqXHR.responseText, -1);
    $('#logger-wrapper').transition({ opacity: 1 });

    /* TODO: this is ridiculous, dammit... */
    setTimeout(function () {
      var h = $('#logger-wrapper').css('height');
      $('#display')
        .transition({ height: h }, 140 );
    }, 10);

  });

});
