function getNaturalWidth(obj, text){
    var clone = obj.clone();
    clone.css("visibility","hidden").css('width', 'auto').html(text);
    $('body').append(clone);
    var width = clone.css('width');
    clone.remove();
    return width;
}


$('p').hyphenate('en-gb');

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


$('#compile').click(function() {

  $('#display').transition({ 'min-height': '6em' });

  $('.diagram').transition({ opacity: 0 });
  $('.loader').transition({ opacity: 1 });

  $('#compile')
    .attr('disabled', true)
    .html("Compiling&hellip;");

  var longWaitTimerId = setTimeout(function () {
    $('.loader-message')
      .html("Server asleep: waking up the poor thing.");
  }, 2400);

  $.ajax({
    method: 'POST',
    url: 'https://texrhobot.herokuapp.com/svg',
    // url: 'http://0.0.0.0:5000/svg',
    data: {
      "document": editor.getValue()
    }
  }).done(function(data) {
    clearTimeout(longWaitTimerId);
    var svg = $(data).find("svg");
    var exHeight = parseFloat(svg.attr('height'))/parseFloat("4.30554pt")+"ex";
    var exWidth = parseFloat(svg.attr('width'))/parseFloat("4.30554pt")+"ex";
    svg.attr('height', exHeight);
    svg.attr('width', exWidth);

    $('.diagram')
      .transition({ height: exHeight, duration: 150 })
      .html(svg)
      .transition({ opacity: 1 },  150, 'snap' );
    $('.loader').transition({ opacity: 0 });

    $('.loader-message').html('');
    $('#compile')
      .html("Tweak the code!");


  }).fail(function(err) {
    console.log( err );
  });


});
