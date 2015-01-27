app.factory('GitHubUtils', function() {
  return {
    getIssues: function(repo) {
      var REPO, octo;
      octo = new Octokat({
        token: "__OAUTH_TOKEN__"
      });
      REPO = octo.repos(repo);
      return REPO.issues.fetch({
        state: 'all'
      });
    }
  };
});
