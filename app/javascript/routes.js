import VueRouter from 'vue-router';
import NotesShow from './components/pages/notes/show.vue';

const routes = [
  {path: '/notes/:id/new_viewer', component: NotesShow}
];

export default new VueRouter({ mode:'history', routes });
