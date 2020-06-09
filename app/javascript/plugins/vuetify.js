import Vue from 'vue';
import Vuetify from 'vuetify';
import 'vuetify/dist/vuetify.min.css';
import '@mdi/font/css/materialdesignicons.css';

Vue.use(Vuetify);

const opts = {
  theme: {
    themes: {
      light: {
        primary: '#F75C2F',
        secondary: '#999999',
        project: '#F75C2F',
        request_box: '#2EA9DF',
        twitter: '#1DA1F2'
      }
    },
    options: {
      customProperties: true
    }
  },
  icons: {
    iconfont: 'mdi'
  }
};

export default new Vuetify(opts);
