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
      v-btn(@click="onSubmit" rounded color="primary" :disabled="text.length == 0").follow-btn.font-weight-bold コメントする

      v-snackbar(v-model="snackbarEnabled" timeout=3000) {{snackbarText}}
    vue-recaptcha(ref="recaptchaV2" v-if="recaptchaV2Enabled" @verify="onVerifyRecaptchaV2" :sitekey="recaptchaKeyV2")
</template>

<script>
import VueRecaptcha from 'vue-recaptcha'
import { load } from 'recaptcha-v3'

const recaptchaKeyV2 = '6LejIbEUAAAAADO263cfRghHFoAvL_SuykU5tfV2'
const recaptchaKeyV3 = '6Lf4JqgUAAAAANnrDZwns_XB_Sw0Vm3KdSKROLZk'

export default {
  name: 'comment-form',
  components: {
    VueRecaptcha
  },
  data: () => {
    return {
      text: '',
      showAuthor: false,
      snackbarEnabled: false,
      snackbarText: '',
      recaptchaV3: null,
      recaptchaV2Enabled: false
    };
  },
  async created() {
    // reCAPTCHA v2のスクリプトをロード
    const recaptchaV2Script = document.createElement('script')
    recaptchaV2Script.setAttribute('src', 'https://www.google.com/recaptcha/api.js?onload=vueRecaptchaApiLoaded&render=explicit');
    document.body.appendChild(recaptchaV2Script);

    this.recaptchaV3 = await load(recaptchaKeyV3)
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
    },
    recaptchaKeyV2: () => recaptchaKeyV2
  },
  methods: {
    postComment(token, usingCheckbox) {
      return this.axios.post(`/api/v1/notes/${ this.$route.params.id }/comments`, this.deepSnakeCase({
        comment: this.newComment,
        recaptcha: { token, usingCheckbox }
      }))
    },
    showSnackbar(message) {
      // 連続してメッセージを表示する場合を考え、一度非表示にして再度表示する
      this.snackbarEnabled = false
      this.snackbarText = message
      this.$nextTick(() => { this.snackbarEnabled = true })
    },
    onSubmit() {
      this.recaptchaV3.execute('social').then(token => {
        this.postComment(token, false)
        .then((response) => {
          this.showSnackbar(response.data.message)
          this.text = ''
          this.showAuthor = false
        })
        .catch((error) => {
          switch(error.response.data.code) {
            case 'recaptcha_failed':
              this.showSnackbar('「私はロボットではありません」をチェックして下さい。')
              this.recaptchaV2Enabled = true
              break
            default:
              this.showSnackbar(error.response.data.message)
          }
        })
        .then(() => {
          // always executed
          this.$emit('refreshComments')
        })
      })
    },
    onVerifyRecaptchaV2(token) {
      this.postComment(token, true)
      .then((response) => {
        this.showSnackbar(response.data.message)
        this.text = ''
        this.showAuthor = false
      })
      .catch((error) => {
        this.showSnackbar(error.response.data.message)
      })
      .then(() => {
        // always executed
        this.$refs.recaptchaV2.reset()
        this.recaptchaV2Enabled = false
        this.$emit('refreshComments')
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
