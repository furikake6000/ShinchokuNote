import Vue from 'vue';
import Vuetify from 'vuetify';
import 'vuetify/dist/vuetify.min.css';

Vue.use(Vuetify);

const opts = {
  theme: {
    themes: {
      light: {
        primary: '#F75C2F',
        secondary: '#999999'
      }
    },
    options: {
      customProperties: true
    }
  }
};

export default new Vuetify(opts);
