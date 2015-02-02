var app;

app = angular.module('okkiStan', ['ngRoute', 'ngResource', 'ui.sortable', 'ngSanitize', 'btford.markdown', 'firebase']);

app.config([
  '$routeProvider', function($routeProvider) {
    $routeProvider.when('/', {
      name: 'index',
      templateUrl: 'partials/index.html',
      controller: 'IndexController'
    }).otherwise({
      name: '404',
      templateUrl: 'partials/notthere.html',
      controller: 'NotThereController'
    });
  }
]);
