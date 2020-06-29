import Hello from './components/pages/Hello.vue';
import Vue from 'vue';

document.addEventListener('DOMContentLoaded', () => {
  // Vueが使われていないページでは無効化
  if (document.getElementById('app') == null) {
    return;
  }

  new Vue({
    el: '#app',
    components: { Hello }
  });
});
