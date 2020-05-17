import Vue from 'vue';
import VueRouter from 'vue-router';
import router from './routes';
import vuetify from './plugins/vuetify';

Vue.use(VueRouter);

document.addEventListener('DOMContentLoaded', () => {
  // Vueが使われていないページでは無効化
  if (document.getElementById('app') == null) {
    return;
  }

  new Vue({
    el: '#app',
    template: '<router-view />',
    router,
    vuetify,
    mounted: function() {
      console.log(this.$route.path);
    }
  });
});
