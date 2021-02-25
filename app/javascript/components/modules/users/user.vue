<template lang="pug">
  .white.pa-5.rounded-xl
    v-avatar(size="100px")
      img(:src="thumbUrl")
    .name {{name}}
    a(:href="twitterUrl").secondary--text.text--lighten-1
      v-icon(small color="secondary lighten-1") mdi-twitter
      span @{{twitterScreenName}}
    .my-3.body-2 {{desc}}
    .notes.mt-3(v-if="projects || requestBoxes")
      .text-center.mt-4.secondary--text(v-if="projects.length > 0") 最近のノート
      template(v-for="note in projects")
        note(v-bind="note").my-4
      .text-center.secondary--text(v-if="requestBoxes.length > 0") リクエストボックス
      template(v-for="note in requestBoxes")
        note(v-bind="note").my-4

    v-btn(:href="url" outlined block color="primary") マイページへ
</template>

<script>
import Note from '../../modules/notes/note.vue';

export default {
  name: 'user',
  props: {
    name: String,
    desc: String,
    thumbUrl: String,
    url: String,
    twitterUrl: String,
    twitterScreenName: String,
    projects: Array,
    requestBoxes: Array
  },
  components: {
    Note
  }
};
</script>

<style lang="sass" scoped>
.name
  font-weight: bold
  font-size: 1.5rem
.notes
  border-top: 5px dotted var(--v-secondary-lighten2)
</style>
