// java script functions used in conjection with Project Status Page

function expandCollapse() {
// Get the parent table
var table = this.parentNode;
if(table.tagName.match(/^table$/i)) { // Check it is indeed a table
// Go through each row, hiding it or showing it...
var tableBody = table.getElementsByTagName('tbody')[0];
var bodyRows = tableBody.getElementsByTagName('tr');
for(var rowsI = 0; rowsI < bodyRows.length; rowsI++) {
if(this.className == 'collapse') bodyRows[rowsI].className = 'hidden';
else if(this.className == 'expand') bodyRows[rowsI].className = '';
}

// change our class
if(this.className == 'collapse') this.className = 'expand';
else if(this.className == 'expand') this.className = 'collapse';
}
}

function collapsibleTables() {
// Find all the tables in the document
var allTables = document.getElementsByTagName('table');
// go through each table
for(var tablesI = 0; tablesI < allTables.length; tablesI++) {
// Find the head section
var head = allTables[tablesI].getElementsByTagName('thead')[0];
if(head) {
// Change it's class, and give it an onclick
head.className = "collapse";
head.onclick = expandCollapse;
}
}
}

window.onload = function() {
// All the things to do when the window loads
collapsibleTables();
}


