//=[ Editors ]==================================================================

var editor = ace.edit("editor");
editor.setValue(document.getElementById("example").text.trim(), 0);
editor.setTheme("ace/theme/chrome");
editor.getSession().setMode("ace/mode/latex");
editor.setOptions({
  fontSize: 16,
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
  readOnly: true,
  showGutter: false,
  fontSize: 16,
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

  const ptPerEx = 4.3
  var svg = data.querySelector('svg')
  var exHeight = parseFloat(svg.getAttribute('height')) / ptPerEx + "ex";
  var exWidth = parseFloat(svg.getAttribute('width')) / ptPerEx + "ex";
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
  timeout: 10000,
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
