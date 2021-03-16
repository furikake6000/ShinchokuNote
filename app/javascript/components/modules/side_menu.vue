<template lang="pug">
  .side-menu
    .d-flex.flex-column.pa-4
      .pop.shinchoku-dodeska
        span.number {{shinchokuDodeskasCount}}
        span.ml-1 進捗どうですか
      shinchoku-button.mb-4
      .pop(:class="watchingStatus && 'primary-color'")
        span.number {{watchersCount}}
        span.ml-1 ウォッチ中
      v-btn.ml-1.mb-4(
        @click="toggleWatching"
        :loading="loadingWatchButton"
        :color="watchingStatus ? 'primary' : 'secondary'"
        :outlined="watchingStatus"
        fab small
      )
        v-icon {{ watchingStatus ? 'mdi-star-check' : 'mdi-star-plus' }}
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
            v-btn(
              v-on="on" fab dark small color="twitter"
              :href="twitterIntentUrl"
              target="_new"
              rel="noopener noreferrer"
            )
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

    v-snackbar(v-model="snackbarEnabled" timeout=3000) {{snackbarText}}

    v-dialog(v-model="loginDialogEnabled" width="400")
      v-card
        v-card-title
        v-card-text ウォッチリストの登録にはログインが必要です。
        v-card-actions
          v-spacer
          v-btn.font-weight-bold(@click="loginDialogEnabled = false" text color="secondary") キャンセル
          v-btn.font-weight-bold(href="/login" text color="primary") ログイン/新規登録
</template>

<script>
import ShinchokuButton from '../modules/shinchoku_dodeskas/shinchoku_button.vue';

export default {
  name: 'side-menu',
  props: {
    watchersCount: Number,
    shinchokuDodeskasCount: Number,
    commentsCount: Number,
    name: String,
    isWatching: Boolean
  },
  data: () => {
    return {
      currentUrlCopied: false,
      stampFormEnabled: false,
      snackbarEnabled: false,
      snackbarText: '',
      loadingWatchButton: false,
      watchingStatus: false,
      loginDialogEnabled: false
    };
  },
  mounted (){
    this.watchingStatus = this.isWatching
  },
  methods: {
    copyCurrentUrl() {
      document.getElementById('current_url_field').select();
      document.execCommand('copy');
      this.currentUrlCopied = true;

      // 10秒後に表示をもとに戻す
      setTimeout(() => {
        this.currentUrlCopied = false;
      }, 10000);
    },
    showSnackbar(message) {
      // 連続してメッセージを表示する場合を考え、一度非表示にして再度表示する
      this.snackbarEnabled = false
      this.snackbarText = message
      this.$nextTick(() => { this.snackbarEnabled = true })
    },
    toggleWatching() {
      // 未ログイン状態ならばダイアログ表示
      if (!this.loggedIn) {
        this.loginDialogEnabled = true
        return
      }

      const url = `/api/v1/notes/${ this.$route.params.id }/watchlist`
      const func = this.watchingStatus ? this.axios.delete(url) : this.axios.post(url)

      // ロード状態に
      this.loadingWatchButton = true
      // イベント発火
      func.then((response) => {
        this.showSnackbar(response.data.message)
        this.watchingStatus = !this.watchingStatus
      })
      .catch((error) => {
        this.showSnackbar(error.response.data.message)
      })
      .then(() => {
        // always executed
        this.loadingWatchButton = false
        this.$emit('fetchNote')
      })
    }
  },
  computed: {
    currentUrl() {
      return location.href;
    },
    twitterIntentUrl() {
      return `https://twitter.com/share?text=${encodeURIComponent(this.name)}&url=${location.href}&hashtags=進捗ノート`
    },
    loggedIn() {
      return document.querySelector('meta[name="logged_in"]').content.toLowerCase() === 'true' 
    }
  },
  watch: {
    isWatching(val) {
      // isWatchingが変化した時、watchingStatusを変化させる
      // (逆は然りでない)
      this.watchingStatus = val
    }
  },
  components: {
    ShinchokuButton
  }
};
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
    &.primary-color
      background-color: var(--v-primary-lighten1)
      &::after
        border-top-color: var(--v-primary-lighten1)
  a.v-btn
    text-decoration: none
  .v-btn--outlined
    background-color: white
    border-width: 2.5px
</style>
