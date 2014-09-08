'use strict';

/* Filters */
/* All data binding off?  Inject 'appFilters' into angular.module in app.js */

angular.module('appFilters', []).filter('ngbool', function() {
  return function(input) {
    return input ? 'YES' : 'No';
  };
});
