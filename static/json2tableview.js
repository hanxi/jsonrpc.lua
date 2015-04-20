// This function creates a standard table with column/rows
// Parameter Information
// objArray = Anytype of object array, like JSON results
// theme (optional) = A css class to add to the table (e.g. <table class="<theme>">
// enableHeader (optional) = Controls if you want to hide/show, default is show
function CreateTableView(objArray, theme, enableHeader) {
   // set optional theme parameter
   if (theme === undefined) {
       theme = 'mediumTable'; //default theme
   }

   if (enableHeader === undefined) {
       enableHeader = true; //default enable headers
   }

   // If the returned data is an object do nothing, else try to parse
   var array = typeof objArray != 'object' ? JSON.parse(objArray) : objArray;

   var str = '<table class="' + theme + '">';
   
   // table head
   if (enableHeader) {
       str += '<thead><tr class="alt">';
       for (var index in array[0]) {
           str += '<th scope="col">' + array[0][index] + '</th>';
       }
       str += '</tr></thead>';
   }
   
   // table body
   str += '<tbody>';
   for (var i = 1; i < array.length; i++) {
       str += (i % 2 == 0) ? '<tr class="alt">' : '<tr>';
       for (var index in array[i]) {
           str += '<td>' + array[i][index] + '</td>';
       }
       str += '</tr>';
   }
   str += '</tbody>'
   str += '</table>';
   return str;
}

