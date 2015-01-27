/**
IndexController. Responsible for the index view.
 */
app.controller("IndexController", function($scope, $route, $filter, GitHubUtils) {
  var issueList;
  $scope.whatsMyName = "Git issues";
  $scope.routename = $route.current.name;
  $scope.board = {};
  $scope.board.columns = [
    {
      name: 'Open issues',
      filter: 'open'
    }, {
      name: 'Issues in progress',
      filter: 'progress'
    }, {
      name: 'Closed issues',
      filter: 'closed'
    }
  ];
  $scope.board.issues = [];
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
  $scope.repo = 'TuvokVersatileKolinahr/optionals';
  issueList = GitHubUtils.getIssues($scope.repo);
  issueList.then(function(list) {
    angular.forEach($scope.board.columns, function(v, k) {
      v.issues = $filter('filter')(list, {
        state: v.filter
      });
    });
    console.log($scope.board);
    $scope.$apply();
  });
  $scope.updateList = function() {
    issueList = GitHubUtils.getIssues($scope.repo);
    return issueList.then(function(list) {
      console.log(list);
      $scope.issues = list;
      $scope.$apply();
    });
  };
});