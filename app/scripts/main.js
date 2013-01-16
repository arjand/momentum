require.config({
  shim: {
  	'paper' : {
    	exports: 'paper'//export the paper global var! -- no need to work with 
    },
  },

  paths: {
    jquery: 'vendor/jquery.min',
    paper:  '../components/paper.js/paper'
  }
});
 
require(['app'], function(app) {
  // use app here  
  
});