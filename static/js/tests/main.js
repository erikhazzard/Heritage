(function() {

  require.config({
    baseUrl: '/static/js',
    urlArgs: "v=" + (new Date()).getTime(),
    shim: {
      'lib/backbone': {
        deps: ['lib/underscore', 'lib/jquery'],
        exports: 'Backbone'
      }
    }
  });

  require(['require', 'lib/chai', 'lib/mocha'], function(require, chai) {
    var assert, expect, should;
    assert = chai.assert;
    should = chai.should();
    expect = chai.expect;
    mocha.setup('bdd');
    return require(['tests/tests'], function() {
      return mocha.run();
    });
  });

}).call(this);
