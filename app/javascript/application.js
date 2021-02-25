import Vue from 'vue';
import App from './app.vue';

// plugins
import VueRouter from 'vue-router';
import router from './routes';
import vuetify from './plugins/vuetify';
import axios from 'axios';
import VueAxios from 'vue-axios';

Vue.use(VueRouter);
Vue.use(VueAxios, axios);

// mixins
import datestr from './mixins/datestr';
import deepCamelSnake from './mixins/deep_camel_snake';

Vue.mixin(datestr);
Vue.mixin(deepCamelSnake);

// CSRF Tokenをaxiosで用いる
axios.defaults.headers.common = {
  'X-Requested-With': 'XMLHttpRequest',
  'X-CSRF-TOKEN' : document.querySelector('meta[name="csrf-token"]').getAttribute('content')
};

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
