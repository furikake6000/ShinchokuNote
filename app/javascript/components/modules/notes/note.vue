<template lang="pug">
  v-card.note-card
    a(:href="url")
      .bgstr(:class="noteIconColor")
        v-icon {{noteTypeIcon}}
      template(v-if="thumbUrl")
        v-img(
          :src="thumbUrl" height="200px"
          gradient="to bottom, rgba(0, 0, 0, 0), rgba(0, 0, 0, .5)"
        ).white--text.align-end
          v-card-title.headline
            span.mr-2.note-card-title {{name}}
            note-badges(:stage="stage" :viewStance="viewStance" :rating="rating")
      .note-card-content
        template(v-if="!thumbUrl")
          v-card-title.headline
            span.mr-2.note-card-title {{name}}
            note-badges(:stage="(this.type == 'request_box' ? null : this.stage)" :viewStance="viewStance" :rating="rating")
        v-card-subtitle {{desc}}
        v-card-actions
          v-spacer
          v-tooltip(top)
            template(v-slot:activator="{ on }")
              v-btn(text color="secondary" v-on="on")
                v-icon mdi-star
                span {{watchersCount}}
            span フォローする
        
</template>

<script>
import NoteBadges from './note_badges.vue';

const noteTypeIcons = {
  'project': 'mdi-note-text',
  'request_box': 'mdi-email'
}
const noteIconColors = {
  'project': 'project--text text--lighten-5',
  'request_box': 'request_box--text text--lighten-3'
}

export default {
  name: 'note',
  props: {
    type: String,
    name: String,
    desc: String,
    thumbUrl: String,
    url: String,
    watchUrl: String,
    stage: String,
    viewStance: String,
    rating: String,
    watchersCount: Number
  },
  components: {
    NoteBadges
  },
  computed: {
    noteTypeIcon: function() {
      return noteTypeIcons[this.type];
    },
    noteIconColor: function() {
      return noteIconColors[this.type];
    }
  }
}
</script>

<style scoped lang="sass">
.note-card
  position: relative
  overflow: hidden
  a
    color: rgba(0, 0, 0, .87)
    &:hover
      text-decoration: none
  .note-card-title
    display: -webkit-box
    -webkit-box-orient: vertical
    -webkit-line-clamp: 2
    overflow: hidden
  .note-card-content
    position: relative
    z-index: 1
  .v-image
    position: relative
    z-index: 1
  .v-card__subtitle
    display: -webkit-box
    -webkit-box-orient: vertical
    -webkit-line-clamp: 3
    overflow: hidden
    padding-bottom: 0
    margin-bottom: 1rem
</style>
