<template lang="pug">
  .comment-form
    v-textarea(
      v-model="text"
      label="新しいコメントを入力する..."
      rows=0
      auto-grow
    )
    .d-flex.align-center
      v-switch.ma-0(v-model="showAuthor" label="投稿者を公開する")
      span.secondary--text.subtitle-1.font-weight-bold.ml-auto.mr-4 {{text.length}} / 1000
      v-btn(@click="postComment" rounded color="primary" :disabled="text.length == 0").follow-btn.font-weight-bold コメントする
</template>

<script>
export default {
  name: 'comment-form',
  data: () => {
    return {
      text: '',
      showAuthor: false
    };
  },
  computed: {
    anonimity() {
      return this.showAuthor ? 'open' : 'secret'
    },
    newComment() {
      return {
        text: this.text,
        anonimity: this.anonimity
      }
    }
  },
  methods: {
    postComment() {
      this.axios.post(`/api/v1/notes/${ this.$route.params.id }/comments`, {
        comment: this.newComment
      })
      .then((response) => {
        console.log(response)
      })
    }
  }
};
</script>

<style lang="sass" scoped>
</style>

<style lang="sass">
  .comment-form
    .v-text-field label.v-label
      color: var(--v-secondary-lighten2)
      font-weight: bold
</style>
