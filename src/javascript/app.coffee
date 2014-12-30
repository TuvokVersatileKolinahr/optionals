# This is the okkistan app
app = angular.module 'okkiStan',
  ['ngRoute', 'ngResource', 'checklist-model', 'firebase']

app.config [
  '$compileProvider',
  ($compileProvider) ->
    # explicitly add URL protocols to Angular's whitelist
    $compileProvider.aHrefSanitizationWhitelist /^\s*(https?|javascript):/
    return
  ]
app.config [
  '$routeProvider',
  ($routeProvider) ->
    $routeProvider
      .when '/zwadonk',
        templateUrl: 'partials/zwadonk.html',
        controller: 'MainController'
      .when '/fnurkels',
        templateUrl: 'partials/fnurkels.html',
        controller: 'FnurkelsController'
      .when '/messages',
        templateUrl: 'modules/messages/messages.html',
        controller: 'MessagesController'
      .when '/impress',
        templateUrl: 'modules/impress/impress.html',
        controller: 'ImpressController'
      .otherwise
        redirectTo: '/impress'
      return
  ]
