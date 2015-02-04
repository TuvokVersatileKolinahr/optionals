app.factory('GitHubUtils', function() {
  var githubUtils = {};

  githubUtils.getIssues = function(repo, token) {
    var REPO, octo;
    octo = new Octokat({
      token: token
    });
    REPO = octo.repos(repo);
    return REPO.issues.fetch({
      state: 'all'
    });
  };

  return githubUtils;
});
