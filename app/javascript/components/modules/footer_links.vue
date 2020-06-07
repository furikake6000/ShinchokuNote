<template lang="pug">
  v-container
    .footer-links
      .d-flex.justify-center.font-weight-bold
        a.mx-4(href="/terms") 利用規約
        a.mx-4(href="/help") ヘルプ
        a.mx-4(href="/faq") Q&A
        a.mx-4(href="/announces") お知らせ
        a.mx-4(href="https://twitter.com/shinchokunote")
          v-icon.mr-1(color="primary lighten-2" small) mdi-twitter
          span Twitter
        a.mx-4(href="/notes/19600") ご意見はこちらまで
      .d-flex.justify-center.mt-4
        a.logo(href="/" v-html="logo")
</template>

<script>
import logo from "../../assets/images/logo.svg"

export default {
  name: "footer-links",
  data: () => {
    return {
      logo: logo
    }
  }
}
</script>

<style lang="sass" scoped>
  .footer-links a
    color: var(--v-primary-lighten2)
  .logo
    width: 180px
</style>
