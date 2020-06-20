<template lang="pug">
  .side-menu
    .d-flex.flex-column.pa-4
      .pop.shinchoku-dodeska
        span.number {{shinchokuDodeskasCount}}
        span.ml-1 進捗どうですか
      shinchoku-button.mb-4
      .pop
        span.number {{watchersCount}}
        span.ml-1 ウォッチ中
      v-btn.ml-1.mb-4(fab small color="secondary")
        v-icon mdi-star
      .pop
        span.number {{commentsCount}}
        span.ml-1 コメント
      v-btn.ml-1(@click="$vuetify.goTo('.comments')" fab small color="secondary")
        v-icon mdi-email

    .pa-4
      .mb-2.secondary--text.font-weight-bold このノートを共有
      v-text-field#current_url_field(:value="currentUrl" readonly filled rounded dense)
      .mt-n4.text-right
        v-tooltip(bottom)
          template(v-slot:activator="{ on }")
            v-btn(v-on="on" fab color="twitter" dark small)
              v-icon mdi-twitter
          span ツイート
        v-tooltip(bottom)
          template(v-slot:activator="{ on }")
            v-btn.ml-2(
              @click="copyCurrentUrl"
              :color="currentUrlCopied ? 'success' : 'secondary'"
              v-on="on" fab small
            )
              v-icon {{currentUrlCopied ? 'mdi-check' : 'mdi-link-variant'}}
          span {{currentUrlCopied ? 'コピーしました！' : 'URLをコピー'}}
</template>

<script>
import ShinchokuButton from "../modules/shinchoku_dodeskas/shinchoku_button.vue"

export default {
  name: "side-menu",
  props: {
    watchersCount: Number,
    shinchokuDodeskasCount: Number,
    commentsCount: Number
  },
  data: () => {
    return {
      currentUrlCopied: false,
      stampFormEnabled: false
    }
  },
  methods: {
    copyCurrentUrl() {
      document.getElementById("current_url_field").select();
      document.execCommand("copy");
      this.currentUrlCopied = true;

      // 10秒後に表示をもとに戻す
      setTimeout(() => {
        this.currentUrlCopied = false;
      }, 10000);
    }
  },
  computed: {
    currentUrl() {
      return location.href;
    }
  },
  components: {
    ShinchokuButton
  }
}
</script>

<style lang="sass" scoped>
  .side-menu
    position: relative
  .pop
    position: relative
    margin-right: auto
    margin-bottom: 15px
    padding: 0 10px 5px 10px
    border-radius: 10px
    background-color: var(--v-secondary-lighten1)
    color: white
    font-weight: bold
    opacity: 0.8
    span
      font-size: .75rem
      &.number
        font-size: 1.2rem
    &::after
      content: ''
      position: absolute
      display: block
      width: 0
      left: 15px
      bottom: -10px
      border-top: 10px solid var(--v-secondary-lighten1)
      border-right: 10px solid transparent
      border-left: 10px solid transparent
    &.shinchoku-dodeska
      background-color: var(--v-shinchoku-lighten1)
      &::after
        left: 20px
        border-top-color: var(--v-shinchoku-lighten1)
</style>
