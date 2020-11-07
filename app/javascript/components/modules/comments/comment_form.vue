<template lang="pug">
  .comment-form
    v-textarea(
      v-model="newComment.text"
      label="新しいコメントを入力する..."
      rows=0
      auto-grow
    )
    .d-flex.align-center
      v-switch.ma-0(label="投稿者を公開する")
      span.secondary--text.subtitle-1.font-weight-bold.ml-auto.mr-4 {{newComment.text.length}} / 1000
      v-btn(rounded color="primary" :disabled="newComment.text.length == 0").follow-btn.font-weight-bold コメントする
</template>

<script>
export default {
  name: 'comment-form',
  data: () => {
    return {
      newComment: {
        text: ''
      }
    };
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
