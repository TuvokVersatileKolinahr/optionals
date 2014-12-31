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
      .when '/module/:moduleName',
        templateUrl: (urlattr) ->
          'modules/' + urlattr.moduleName + '/' + urlattr.moduleName + '.html'
        controller: 'ModulesController'
      .when '/zwadonk',
        templateUrl: 'modules/zwadonk/zwadonk.html'
        controller: 'ZwadonkController'
      .when '/fnurkels',
        templateUrl: 'modules/fnurkels/fnurkels.html'
        controller: 'FnurkelsController'
      .when '/messages',
        templateUrl: 'modules/messages/messages.html'
        controller: 'MessagesController'
      .when '/impress',
        templateUrl: 'modules/impress/impress.html'
        controller: 'ImpressController'
      # .when '/page/:name',
      #   templateUrl: (urlattr) ->
      #     '/pages/' + urlattr.name + '.html'
      #   controller: 'PagesController'
      .when '/',
        templateUrl: 'partials/index.html'
        controller: 'IndexController'
      .otherwise
        templateUrl: 'partials/notthere.html'
        controller: 'NotThereController'
      return
  ]
capitaliseFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)
