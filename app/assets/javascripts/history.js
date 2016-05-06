// Adds the current path along with a given name to the history.
addToHistory = function (name) {
  // Return if browser doesn't support HTML storage (as read
  // here http://www.w3schools.com/html/html5_webstorage.asp).
  if (typeof(Storage) === "undefined")
    return console.log("Statement history disabled since HTML storage is not supported.");

  // Get history from local storage.
  var statementHistory = getHistory();

  // Create a history entry consisting of the path
  // and a name of a route.
  var entry = {
    path: currentPath(),
    name: shortened(name)
  }

  // If the user has visited this path before, interpret this
  // as "go back to" by removing all paths he visited after
  // he visited this path.
  for (var i = statementHistory.length - 1; i >= 0; i--) {
    if (statementHistory[i].path === entry.path) {
      // Remove all entries made after the user lastly
      // visited this current path.
      statementHistory = statementHistory.slice(0, i);
      break;
    }
  }

  // Append this entry to the history.
  statementHistory.push(entry);

  // Refresh html with the new history.
  refreshDisplayedHistory(statementHistory);

  // Store new history in local storage.
  setHistory(statementHistory);
}

var shortened = function (name) {
  if (name.length < 33) return name;
  return name.slice(0, 30) + '...';
}

// Reads in current history from browser storage.
var getHistory = function () {
  var string = localStorage.statementHistory;

  // Initialize history if necessary.
  if (!string || string == '""' || string === '[object Object]') return [];

  return JSON.parse(string);
}

// Saves the given object as new history.
var setHistory = function (statementHistory) {
  var string = JSON.stringify(statementHistory);
  localStorage.statementHistory = string;
}

// Displays the entries of statementHistory on the page.
refreshDisplayedHistory = function (statementHistory) {
  if (!statementHistory)
    statementHistory = getHistory();

  if (statementHistory.length < 2)
    return displayHistory('');

  displayHistory(historyHtml(statementHistory));

  // Make sure the scroll container is at the right.
  $('.statement-history').scrollLeft(99999);
}

// Hides the container of the history on the page.
var displayHistory = function (content) {
  $('#statement-history-anchor').html(content);
}

var currentPath = function () {
  return window.location.pathname + window.location.search;
}

// Takes an array of history entries and returns html
// including links to the given paths named according
// to the given names.
var historyHtml = function (historyArray) {
  var result = '<div class="statement-history">';

  for (var i = 0; i < historyArray.length; i++) {
    var entry = historyArray[i];

    // Hide the entry if it's the last entry and we're
    // on this page right now.
    if (i === historyArray.length - 1 && entry.path === currentPath())
      break;

    result += '<div class="historical-link"># ' + '<a href="' + entry.path + 
      '"><span class="link-expander"></span>' + entry.name + '</a></div> > ';
  }

  return result.slice(0, -3) + '</div>';
}
