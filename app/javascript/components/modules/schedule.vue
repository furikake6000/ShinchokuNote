<template lang="pug">
  .schedule(:class="status")
    .bgstr.small
      v-icon {{statusIcon}}
    .content.text-center
      .headline.font-weight-bold {{text}}
      .body-2.mt-2
        v-icon(small) mdi-clock-outline
        span {{dateStr(scheduledDate)}} まで
        span.ml-4(v-if="finishedDate")
          v-icon(small) mdi-check
          span {{dateStr(finishedDate)}} 完了
</template>

<script>
const dateFormatter = Intl.DateTimeFormat('ja-JP', { month: 'narrow', day: 'numeric' ,hour12: false, hour: '2-digit', minute: '2-digit' });
const statusIcons = {
  'unfinished': 'mdi-clock-outline',
  'finished': 'mdi-check-circle',
  'outdated': 'mdi-clock-outline'
}

export default {
  name: 'post',
  props: {
    id: Number,
    text: String,
    date: Date,
    scheduledDate: Date,
    finishedDate: Date
  },
  data: function() {
    return {
      lightboxEnabled: false,
      lightboxIndex: 0
    }
  },
  computed: {
    status: function() {
      if(this.finishedDate) return 'finished';
      if(this.scheduledDate > Date.now()) return 'unfinished';
      return 'outdated';
    },
    statusIcon: function() {
      return statusIcons[this.status];
    }
  },
  methods: {
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
</style>
