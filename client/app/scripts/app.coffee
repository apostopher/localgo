'use strict'

angular.module('locationdesignerApp', [
  'ngCookies',
  'ngResource',
  'ngSanitize',
  'ngRoute',
  'ui.router',
  'leaflet-directive'
])
  .config ($stateProvider, $urlRouterProvider, $locationProvider) ->
    $locationProvider.html5Mode true
    $urlRouterProvider.otherwise "/"

    $stateProvider
      .state 'home',
        url: '/'
        templateUrl: 'views/main.html'
        controller: 'MainCtrl'

      .state 'login',
        url: '/login'
        templateUrl: 'views/login.html'
        controller: 'LoginCtrl'

  .run ($rootScope, $state, $window) ->
    $rootScope.$on '$stateChangeStart', (event, toState, toParams, fromState, fromParams) ->
      if toState.name is 'login' then return

      logged_in_user = $window.__localgoActiveUser__?.id
      if not logged_in_user
        event.preventDefault()
        $state.go 'login'
