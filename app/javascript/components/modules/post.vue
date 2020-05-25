<template lang="pug">
  .post
    div(:class="textClass") {{text}}
    v-img.my-2(:src="image" v-for="image in images" max-height="600px" contain :key="image")
    .body-2.secondary--text {{timeStr}}
</template>

<script>
const timeFormatter = Intl.DateTimeFormat('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' });

export default {
  name: 'post',
  props: {
    id: Number,
    text: String,
    images: Array,
    date: Date
  },
  computed: {
    textClass: function() {
      if (this.text.length <= 30) return 'display-1';
      if (this.text.length <= 140) return 'headline';
      return 'body-1';
    },
    timeStr: function() {
      return timeFormatter.format(this.date);
    }
  }
}
</script>

<style lang="sass" scoped>
  .post
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
