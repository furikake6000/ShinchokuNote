<template lang="pug">
  .chips
    template(v-if="stage")
      v-chip(:color="stageColor" :small="small" :outlined="outlined").ml-1 {{ stageName }}
    template(v-if="viewStanceName")
      v-chip(color="secondary" :small="small" :outlined="outlined").ml-1
        v-icon mdi-lock
        span {{ viewStanceName }}
    template(v-if="rating=='restricted_18'")
      v-chip(color="error" :small="small" :outlined="outlined").ml-1 R18
</template>

<script>
const stageColors = {
  'idea': 'secondary',
  'in_progress': 'error',
  'finished': 'success',
  'frozen': 'secondary',
  'closed': 'secondary darken-4'
}
const stageNames = {
  'idea': '構想中',
  'in_progress': '進捗中',
  'finished': '完成',
  'frozen': '凍結中',
  'closed': 'お蔵入り'
}
const viewStanceNames = {
  'only_me': '自分のみ',
  'only_follower': 'フォロワーさんのみ',
  'only_signed': '要ログイン',
  'everyone': 'だれでも'
}

export default {
  name: 'note-badges',
  props: {
    stage: String,
    viewStance: String,
    rating: String,
    small: Boolean,
    outlined: Boolean
  },
  computed: {
    stageColor: function() {
      return stageColors[this.stage];
    },
    stageName: function() {
      return stageNames[this.stage];
    },
    viewStanceName: function() {
      // viewStanceがeveryoneのときは表示しない
      if(!this.viewStance || this.viewStance == 'everyone'){
        return null;
      }
      return viewStanceNames[this.viewStance];
    }
  }
}
</script>

<style scoped lang="sass">
</style>
