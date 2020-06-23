<template lang="pug">
  .comments
    .bgstr.top
      v-icon(color="secondary lighten-3") mdi-email
    .comments-title.secondary--text.font-weight-bold コメント({{count}})
    comment-form.mt-2
    v-divider
    v-btn-toggle(borderless dense mandatory v-model="filter")
      v-btn(value="all") すべて
      v-btn(value="unreplied") 未返信
      v-btn(value="favored") お気に入り
    comment.my-4(v-bind="comment" v-for="comment in filteredComments" :key="comment.id")
</template>

<script>
import CommentForm from './comment_form.vue';
import Comment from './comment.vue';

export default {
  name: 'comments',
  props: {
    comments: Array,
    count: Number
  },
  data: function() {
    return {
      filter: 'all'
    };
  },
  computed: {
    filteredComments() {
      switch(this.filter) {
        case 'unreplied':
          return this.comments.filter(c => !c.responsePost && !c.muted);
        case 'favored':
          return this.comments.filter(c => c.favored && !c.muted);
        default:  // includes 'all'
          return this.comments.filter(c => !c.muted);
      }
    }
  },
  components: {
    CommentForm,
    Comment
  }
};
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
