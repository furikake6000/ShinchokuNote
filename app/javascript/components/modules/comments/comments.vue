<template lang="pug">
  .comments
    .comments-title.secondary--text.font-weight-bold コメント(24)
    comment-form.mt-2
</template>

<script>
import CommentForm from "./comment_form.vue";

export default {
  name: "comments",
  components: {
    CommentForm
  }
}
</script>

<style lang="sass" scoped>
  .comments
    padding: 20px
    background-color: white
    border-radius: 20px
    .comments-title
      font-size: 1.5rem
</style>
