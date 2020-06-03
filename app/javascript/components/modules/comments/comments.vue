<template lang="pug">
  .comments
    .bgstr.top
      v-icon(color="secondary lighten-3") mdi-email
    .comments-title.secondary--text.font-weight-bold コメント({{count}})
    comment-form.mt-2
    comment.my-4(v-bind="comment" v-for="comment in comments" :key="comment.id")
</template>

<script>
import CommentForm from "./comment_form.vue";
import Comment from "./comment.vue";

export default {
  name: "comments",
  props: {
    comments: Array,
    count: Number
  },
  components: {
    CommentForm,
    Comment
  }
}
</script>

<style lang="sass" scoped>
  .comments
    position: relative
    overflow: hidden
    padding: 20px
    background-color: white
    border-radius: 20px
    .comments-title
      font-size: 1.5rem
</style>
