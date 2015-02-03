/**
IndexController. Responsible for the index view.
 */
app.controller("IndexController", function($scope, $route, $filter, $firebase, GitHubUtils) {
  var issueList, ref, sync;
  $scope.whatsMyName = "Git issues";
  $scope.routename = $route.current.name;
  $scope.repo = 'TuvokVersatileKolinahr/optionals';
  $scope.board = {};
  $scope.board.issues = [];
  $scope.board.columns = [
    {
      name: 'Open issues',
      filter: 'open'
    }, {
      name: 'Issues in progress',
      filter: 'progress'
    }, {
      name: 'Ready for testing',
      filter: 'testing'
    }, {
      name: 'Closed issues',
      filter: 'closed'
    }
  ];
  $scope.issueSortOptions = {
    itemMoved: function(event) {
      console.log('itemMoved', event);
      return true;
    },
    orderChanged: function(event) {
      console.log('orderChanged', event);
      return true;
    }
  };

  $scope.getIssueList = function(token) {
    issueList = GitHubUtils.getIssues($scope.repo, token);
    issueList.then(function(list) {
      angular.forEach($scope.board.columns, function(v, k) {
        v.issues = $filter('filter')(list, {
          state: v.filter
        });
      });
      console.log($scope.board);
      $scope.$apply();
    });
  };

  $scope.updateList = function() {
    issueList = GitHubUtils.getIssues($scope.repo);
    return issueList.then(function(list) {
      console.log(list);
      $scope.issues = list;
      $scope.$apply();
    });
  };

  ref = new Firebase("https://optionals.firebaseio.com/");
  sync = $firebase(ref);
  $scope.data = sync.$asObject();
  $scope.login = function() {
    return ref.authWithOAuthPopup('github', function(error, authData) {
      if (error) {
        console.log('Login Failed!', error);
        $scope.errormessage = error.code + ' ' + error.message;
        $scope.$apply();
      } else {
        console.log('Authenticated successfully with payload:', authData);
        $scope.displayName = authData.github.displayName;
        delete $scope.errormessage;
        $scope.getIssueList(authData.github.accessToken);  
        $scope.$apply();
      }
    },{
      remember: "sessionOnly",
      scope: "user,public_repo,read:org"
    });
  };

  $scope.logout = function() {
    ref.unauth;
    delete $scope.displayName;
  };
});