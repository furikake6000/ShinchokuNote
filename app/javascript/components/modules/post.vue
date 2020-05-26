<template lang="pug">
  .schedule(v-if="type == 'schedule'" :class="scheduleStatus")
    .bgstr.small
      v-icon {{scheduleStatusIcon}}
    .content.text-center
      .headline.font-weight-bold {{text}}
      .body-2.mt-2
        v-icon(small) mdi-clock-outline
        span {{dateStr(scheduledDate)}} まで
        span.ml-4(v-if="finishedDate")
          v-icon(small) mdi-check
          span {{dateStr(finishedDate)}} 完了

  .post(v-else)
    .responded-comment.mb-2(v-if="respondedComment")
      .body-2.secondary--text {{respondedComment.from || "名無し"}}さんからのコメント
      .body-1 {{respondedComment.text}}
    .post-balloon
      .body-2.secondary--text(v-if="respondedComment")
        v-icon.secondary--text.lighten-2 mdi-reply
        span コメントへの返信
      div(:class="textClass") {{text}}
      v-img.my-2(:src="image" v-for="(image, index) in images" max-height="600px" contain :key="image" @click="showLightbox(index)")
      .body-2.secondary--text {{timeStr}}
      vue-easy-lightbox(
        v-if="images"
        :visible="lightboxEnabled"
        :imgs="images"
        :index="lightboxIndex"
        @hide="hideLightbox"
      )
</template>

<script>
import Vue from 'vue';
import Lightbox from 'vue-easy-lightbox';
Vue.use(Lightbox);

const timeFormatter = Intl.DateTimeFormat('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' });
const dateFormatter = Intl.DateTimeFormat('ja-JP', { month: 'narrow', day: 'numeric' ,hour12: false, hour: '2-digit', minute: '2-digit' });
const scheduleStatusIcons = {
  'unfinished': 'mdi-clock-outline',
  'finished': 'mdi-check-circle',
  'outdated': 'mdi-clock-outline'
}

export default {
  name: 'post',
  props: {
    id: Number,
    type: String,
    text: String,
    images: Array,
    date: Date,
    scheduledDate: Date,
    finishedDate: Date,
    respondedComment: Object
  },
  data: function() {
    return {
      lightboxEnabled: false,
      lightboxIndex: 0
    }
  },
  computed: {
    textClass: function() {
      if (this.text.length <= 30) return 'display-1';
      if (this.text.length <= 140) return 'headline';
      return 'body-1';
    },
    timeStr: function() {
      return timeFormatter.format(this.date);
    },
    scheduleStatus: function() {
      if(this.finishedDate) return 'finished';
      if(this.scheduledDate > Date.now()) return 'unfinished';
      return 'outdated';
    },
    scheduleStatusIcon: function() {
      return scheduleStatusIcons[this.scheduleStatus];
    }
  },
  methods: {
    showLightbox: function(index) {
      this.lightboxEnabled = true;
      this.lightboxIndex = index;
    },
    hideLightbox: function() {
      this.lightboxEnabled = false;
    },
    dateStr: function(date) {
      return dateFormatter.format(date);
    }
  }
}
</script>

<style lang="sass" scoped>
  .schedule
    position: relative
    overflow: hidden
    padding: 15px
    border-radius: 15px
    word-wrap: break-word
    .content
      position: relative
      z-index: 1
    .v-icon
      color: unset
    color: var(--v-primary-darken1)
    background-color: var(--v-primary-lighten4)
    .bgstr
      color: var(--v-primary-lighten2)
    &.finished
      color: var(--v-success-darken1)
      background-color: var(--v-success-lighten3)
      .bgstr
        color: var(--v-success-lighten2)
    &.outdated
      color: var(--v-error-darken1)
      background-color: var(--v-error-lighten3)
      .bgstr
        color: var(--v-error-lighten2)
  .responded-comment
    position: relative
    padding: 15px
    border-radius: 15px
    margin-right: 15px
    background-color: white
    border: solid 2px var(--v-secondary-lighten2)
    &::before
      content: ""
      position: absolute
      top: 20px
      right: -27px
      z-index: 2
      border: 14px solid transparent
      border-left-color: white
    &::after
      content: ""
      position: absolute
      top: 20px
      right: -30px
      z-index: 1
      border: 14px solid transparent
      border-left-color: var(--v-secondary-lighten2)
  .responded-comment + .post-balloon
    &::before
      content: ""
      position: absolute
      top: -27px
      left: 20px
      z-index: 2
      border: 14px solid transparent
      border-bottom-color: white
    &::after
      content: ""
      position: absolute
      top: -30px
      left: 20px
      z-index: 1
      border: 14px solid transparent
      border-bottom-color: var(--timeline-color)
  .post-balloon
    position: relative
    padding: 15px
    border: solid 2px var(--timeline-color)
    border-radius: 15px
    background-color: white
    word-wrap: break-word
    &::before
      content: ""
      position: absolute
      top: 20px
      left: -27px
      z-index: 2
      border: 14px solid transparent
      border-right-color: white
    &::after
      content: ""
      position: absolute
      top: 20px
      left: -30px
      z-index: 1
      border: 14px solid transparent
      border-right-color: var(--timeline-color)
</style>
