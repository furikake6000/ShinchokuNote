<template lang="pug">
  v-card.note-card
    .bgstr
      v-icon mdi-note-text
    .note-card-content
      v-card-title.headline
        span.mr-2 {{name}}
        note-badges(:stage="stage" :viewStance="viewStance" :rating="rating")
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

export default {
  name: 'note',
  props: {
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
  }
}
</script>

<style scoped lang="sass">
.note-card
  position: relative
  overflow: hidden
  .bgstr
    position: absolute
    z-index: 0
    bottom: -80px
    right: -20px
    white-space: nowrap
    font-size: 14rem
    font-weight: bold
    transform: rotate(-30deg)
    color: var(--v-primary-lighten5)
    &.request
      color: var(--v-accent-lighten2)
    .v-icon
      font-size: unset
      color: unset
  .note-card-content
    position: relative
    z-index: 1
</style>
