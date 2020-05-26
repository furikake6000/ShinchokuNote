import Vue from 'vue';
import App from './app.vue';
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
    template: '<app />',
    components: { App },
    router,
    vuetify
  });
});
