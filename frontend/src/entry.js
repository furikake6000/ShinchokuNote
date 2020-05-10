import Vue from 'vue';

// pages
import vueTest from './components/vueTest';

document.addEventListener('DOMContentLoaded', function(event) {
  // Return if Vue.js is not used
  if (document.getElementById('app') == null) {
    return;
  }

  new Vue({
    el: '#app',
    components: {
      'vue-test': vueTest
    }
  });
});
