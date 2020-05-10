import Vue from 'vue';

document.addEventListener('DOMContentLoaded', function(event) {
  // Return if Vue.js is not used
  if (document.getElementById('app') == null) {
    return;
  }

  new Vue({
    el: '#app',
    data: {
      name: 'Hello, vue.js!'
    }
  });
});
