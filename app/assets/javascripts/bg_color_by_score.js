var redHEX = '#FF0022';
var greenHEX = '#00FF33';
var gradient = tinygradient(redHEX, greenHEX);
var hsvGradient = gradient.hsv(100);

var colorForScore = function (score) {
  if (!score && score !== 0) return '#aaa';

  var colorNumber = Math.round(score * 99);
  var hexColor = hsvGradient[colorNumber].toHexString();

  return hexColor;
}

function setBgColorByScore() {
  var $badges = $('[data-bg-color-by-score]');

  $badges.each(function(index) {
    var scoreString = $(this).attr('data-bg-color-by-score');
    var score = parseFloat(scoreString);
    var colorCode = colorForScore(score);

    $(this).css('background-color', colorCode);
  });
}
