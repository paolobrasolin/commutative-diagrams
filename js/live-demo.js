//=[ Editors ]==================================================================

var editor = ace.edit("editor");
editor.setValue(document.getElementById("example").text.trim() + "\n", -1);
editor.setTheme("ace/theme/chrome");
editor.getSession().setMode("ace/mode/latex");
editor.setShowFoldWidgets(false);
editor.setOptions({
  fontSize: "1rem",
  maxLines: 20,
  minLines: 5
});
editor.on('change', function () {
  setCTA({ message: "Compile!", active: true, waiting: false });
});

var logger = ace.edit("logger");
// logger.setTheme("ace/theme/chrome");
// logger.getSession().setMode("ace/mode/latex");
logger.setOptions({
  fontSize: "1rem",
  readOnly: true,
  showGutter: false,
  maxLines: Infinity,
});

//=[ UI helpers ]===============================================================

function setCTA({ message, active, waiting } = {}) {
  document.getElementById('actuator').disabled = !active
  document.getElementById('actuator-throbber').hidden = !waiting
  document.getElementById('actuator-label').textContent = message
}

function fadeInLogger(message) {
  logger.setValue(message, -1);
  logger.container.classList.remove('collapsed')
}

function fadeOutLogger() {
  logger.setValue('', -1);
  logger.container.classList.add('collapsed')
}

function fadeInDiagram(data) {
  const diagram = document.getElementById('diagram')

  const zoom = 1.5
  const ptPerEm = 9.96264 // just render a \rule{1em}{1em} to get this
  var svg = data.querySelector('svg')
  var exHeight = parseFloat(svg.getAttribute('height')) / ptPerEm * zoom + "rem";
  var exWidth = parseFloat(svg.getAttribute('width')) / ptPerEm * zoom + "rem";
  svg.setAttribute('height', exHeight);
  svg.setAttribute('width', exWidth);

  diagram.firstChild.replaceWith(svg)
  diagram.style.height = exHeight;

  diagram.classList.remove('collapsed')
}

function fadeOutDiagram() {
  const diagram = document.getElementById('diagram')

  var svg = document.createElement('svg')

  diagram.firstChild.replaceWith(svg)

  diagram.classList.add('collapsed')
}

//=[ Application loop ]=========================================================

setCTA({ message: "Spinning up server...", active: false, waiting: true });
$.ajax({
  method: 'GET',
  url: 'https://texrhobot.herokuapp.com/',
  timeout: 30000,
  cache: false,
}).done(function () {
  setCTA({ message: "Compile!", active: true, waiting: false });
}).fail(function () {
  setCTA({ message: "Oh noes! Server unreachable! :(", active: false, waiting: false });
});

$('#actuator').click(function () {
  setCTA({ message: "Compiling...", active: false, waiting: true })
  document.querySelector('header').classList.add('small')
  fadeOutDiagram()
  fadeOutLogger();
  $.ajax({
    method: 'POST',
    url: 'https://texrhobot.herokuapp.com/crank',
    data: {
      "document": editor.getValue(),
      'template': 'latex-minimal',
      'format': 'commutative-diagrams-livedemo',
    },
  }).done(function (data) {
    setCTA({ message: "Tweak the code!", active: false, waiting: false })
    fadeInDiagram(data)
    fadeOutLogger()
  }).fail(function (jqXHR, textStatus, errorThrown) {
    setCTA({ message: "Fix the code!", active: false, waiting: false })
    fadeInLogger(jqXHR.responseText.trim())
    fadeOutDiagram()
  });

});
