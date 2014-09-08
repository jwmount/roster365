// To add API calls follow https://docs.angularjs.org/tutorial/step_08

// Initialize Angular App
var app = angular.module("app", 
    ['ngRoute', 
    'ngAnimate', 
    'ngSanitize', 
    'appFilters',
    'autocomplete']);

// Set Config Variables
// Local testing:
//   url: localhost:8082  with http://localhost:3000/api (below)
// app.server = "http://localhost:3000/api";
// Deployment:
// use url=  http://localhost:3000/api/locations/san%20raf with prod server below
app.server = "http://roster365.herokuapp.com/api";
app.locations_api_call = app.server + "/projects/";
app.providers_api_call = app.server + "/quotes/";
app.provider_api_detail = app.server + "/project/";

// Set headers for CORS (both dev & prod)
app.config(['$httpProvider', function($httpProvider) {
        $httpProvider.defaults.useXDomain = true;
        delete $httpProvider.defaults.headers.common['X-Requested-With'];
    }
]);


// Routes
// -------------------------------
app.config(function($routeProvider) {
    $routeProvider.when('/', {
        // Home
        templateUrl: "home.html",
        controller: "HomeController"
    })
    .when('/about', {
        // ABOUT
        templateUrl: "partials/about.html"
        // controller: "AboutController"
    })
    .when('/contact', {
        // ABOUT
        templateUrl: "contact_us.html"
        // controller: "contact_usController"
    })
    .when('/facts', {
        // FactSheets
        templateUrl: "partials/fact_sheets.html"
        // controller: "fact_sheetsController"
    })
    .when('/faq', {
        // FAQ
        templateUrl: "faq.html"
        // controller: "FaqController"
    })
    .when('/privacy', {
        // Privacy
        templateUrl: "privacy_policy.html"
        // controller: "privacyController"
    })
    .when('/projects/:projectId', {
        // Provider
        templateUrl: 'partials/project-detail.html',
        controller: 'ProjectDetailCtrl'
    })
    .when('/provider-services', {
        // Provider
        templateUrl: 'partials/provider-detail.html',
        controller: 'ProviderDetailCtrl'
    })
    .when('/research', {
        // Research
        templateUrl: "research.html"
        // controller: "researchController"
    })
    .when('/terms_conditions', {
        // Terms & Conditions
        templateUrl: "terms_conditions.html"
        // controller: "terms_conditionsController"
    })
    .otherwise({
        // Anything Else
        redirectTo: '/'
    });
});



// Controllers
// -------------------------------

// Locations Controller
app.controller("HomeController", function($scope, $http, $timeout) {

    // Fires whenever key is clicked in form.locality field
    // We want to make the API call only when we have two chars in
    // in the form.locality field. After we have that initial list,
    // the autocomplete field further filters the list locally -- no
    // need for another API call.

    $scope.iterProvider = function(provider) {
      $scope.list = Object.keys(provider);
    }

    // Update Locations  # --> https://github.com/JustGoscha/allmighty-autocomplete
    var list_is_current = false;
    $scope.locations = [];           // jwm 08-20-2014
    $scope.updateProjects = function() {
        console.log('list_is_current: ' + list_is_current);
        // Less than two chars?
        if ($scope.form.locality.length < 2 ){
            // Clear locations list and don't do API call
            list_is_current = false;
            $scope.locations = [];
            return;
        }
        // More than two chars and locations list is not current?
        else if ($scope.form.locality.length >= 2 && !list_is_current) {
            $http
            .get(app.locations_api_call + String($scope.form.locality))
            .success(function(data) {
                $scope.locations = data;
                list_is_current = true;
                // console.log(data);
            })
            .error(function (data) {
                // console.log(data)
            });
        }
    };  //updateLocations

    // Update Providers
    $scope.updateProviders = function(suggestion) {
        var params = $scope.form;
        // When updateProviders is called from checkboxes, the suggestion (city, state)
        // is already populated. But when it's called from the autocomplete on-select
        // directive, that event happens BEFORE the form is fully populated, so we
        // pass the <suggestion> arg directly from autocomplete.js
        if (suggestion)
            params.locality = suggestion;

        // Remove any explicit calls to items equal to "false"
        // (for example if a checkbox is checked, then unchecked)
        params = remove_false_attributes(params);

        console.log(params);
        $http({ method: 'GET', url: app.providers_api_call, params: params })
            .success(function(data) {
                $scope.providers = data;
                // console.log(data);
            })
            .error(function (data) {
                // console.log(data)
            });

    } //updateProviders
});  //HomeController


app.controller('ProviderDetailCtrl', ['$scope', '$routeParams', '$http',
    function($scope, $routeParams, $http) {
      $http.get(app.provider_api_detail + $routeParams.providerId + '.json').success(function(data) {
      $scope.provider = data;
    });
      
  }]);


//
// Helpers
//

// Helper function (experimental)
toggleChosenAttribute = function(obj) {
  console.log('prop: chosen');
}
// Helper function
remove_false_attributes = function(obj) {
    for (var prop in obj) {
        // console.log('prop: ' + prop);
        // console.log('obj[prop]: ' + obj[prop]);
        if (obj.hasOwnProperty(prop) && obj[prop] === false)
            delete obj[prop];
    }
    return obj;
}

