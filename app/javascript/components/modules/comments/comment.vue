<template lang="pug">
  .comment
    .comment-text {{text}}
    .d-flex.align-center
      v-btn(text small color="secondary")
        v-icon(small) mdi-reply
        span 返信
      v-btn(@click="toggleFavored" text small :color="favored ? 'primary' : 'secondary'")
        v-icon(small) mdi-star
        span お気に入り
      v-btn(@click="toggleMuted" text small :color="muted ? 'primary' : 'secondary'")
        v-icon(small) mdi-eye-off
        span ミュート
      span.caption.secondary--text.ml-auto {{ dateStr(date) }}
</template>

<script>
import CommentForm from "./comment_form.vue";

const dateFormatter = Intl.DateTimeFormat('ja-JP', {
  month: 'narrow',
  day: 'numeric' ,
  hour12: false,
  hour: '2-digit',
  minute: '2-digit'
});
const dateFormatterWithYear = Intl.DateTimeFormat('ja-JP', {
  year: 'numeric',
  month: 'narrow',
  day: 'numeric' ,
  hour12: false,
  hour: '2-digit',
  minute: '2-digit'
});

export default {
  name: "comment",
  props: {
    id: Number,
    text: String,
    date: Date,
    favored: Boolean,
    muted: Boolean
  },
  methods: {
    dateStr(date) {
      if(date.getFullYear() != new Date().getFullYear()){
        return dateFormatterWithYear.format(date);
      }
      return dateFormatter.format(date);
    }
  }
}
</script>

<style lang="sass" scoped>
</style>
