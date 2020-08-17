<template lang="pug">
  .comments
    .bgstr.top
      v-icon(color="secondary lighten-3") mdi-email
    .comments-title.secondary--text.font-weight-bold コメント({{totalCount}})
    comment-form.mt-2
    v-divider
    v-btn-toggle(borderless dense mandatory v-model="filter")
      v-btn(value="all") すべて
      v-btn(value="unreplied") 未返信
      v-btn(value="favored") お気に入り

    v-pagination.my-4(
      v-model="currentPage" circle
      :length="totalPages"
      :total-visible="9"
      v-if="totalPages != 1"
    )
    comment.my-4(v-bind="comment" v-for="comment in filteredComments" :key="comment.id")
    v-pagination.my-4(
      v-model="currentPage" circle
      :length="totalPages"
      :total-visible="9"
      v-if="totalPages != 1"
    )
</template>

<script>
import CommentForm from './comment_form.vue';
import Comment from './comment.vue';

export default {
  name: 'comments',
  mounted () {
    this.fetchComments();
  },
  data: function() {
    return {
      comments: [],
      totalCount: 0,
      currentPage: 1,
      totalPages: 1,
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
  methods: {
    fetchComments (page = 1) {
      this.axios.get(`/api/v1/notes/${ this.$route.params.id }/comments`, {
        params: {
          page: page
        }
      }).then(response => {
        const data = this.deepCamelCase(response.data);
        this.comments = data.comments;
        this.currentPage = data.meta.currentPage;
        this.totalCount = data.meta.totalCount;
        this.totalPages = data.meta.totalPages;
      });
    }
  },
  watch: {
    currentPage (val) {
      this.fetchComments(val);
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
