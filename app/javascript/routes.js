import VueRouter from 'vue-router';
import NotesShow from './components/pages/notes/show.vue';

const routes = [
  {path: '/notes/:note_id/new_viewer', component: NotesShow}
];

export default new VueRouter({ mode:'history', routes });
