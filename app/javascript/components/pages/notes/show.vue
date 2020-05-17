<template lang="pug">
  v-app
    main
      .cover
        v-container
          h1.name.mt-4.pb-3
            .d-flex.flex-column.flex-md-row
              div.flex-grow-1
                span test
                v-chip(color="success" outlined).ml-2 完成
                v-chip(color="secondary" outlined).ml-2
                  v-icon mdi-lock
                  span 自分のみ
                v-chip(color="error" outlined).ml-2 R18
              .text-left
                v-btn(rounded color="secondary").align-self-center.follow-btn 編集する
          .d-flex.flex-column.flex-md-row.mt-4
            p.
              Lorem ipsum dolor sit amet, consectetur adipiscing elit,
              sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
              Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris
              nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
              reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
              pariatur. 
            .flex-shrink-0.text-right.align-self-end
              .secondary--text.text--lighten-1.font-weight-bold 2019年1月1日作成 (100日め)
    v-container
      v-row
        v-col(cols="8")
          p hi!
        v-col(cols="4")
          .user-info
            v-avatar(size="100px")
              img(src="https://pbs.twimg.com/profile_images/1258916109442404353/I-NTF47_.jpg")
            .user-name ふりかけ
            a(href="https://twitter.com/furikake555").secondary--text.text--lighten-1
              v-icon mdi-twitter
              span @furikake6000
            .user-desc.my-3.pb-3
              p.body-2.
                Lorem ipsum dolor sit amet, consectetur adipiscing elit,
                sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.
              br
              a.body-2.primary--text(href="https://example.com") https://example.com
            .user-notes
              .text-center.secondary--text.text--lighten-1 最近のノート
            v-btn(text block color="primary") マイページへ
</template>

<script>
export default {
}
</script>

<style scoped lang="sass">
#app
  font-family: -apple-system, blinkMacSystemFont, 'Helvetica Neue', 'Segoe UI', 'Yu Gothic', YuGothic, Meiryo, sans-serif
  background-color: #FFF6F3

.container
  @media (min-width: 1264px)
    max-width: 1185px

.cover
  background-color: white
  h1.name
    font-size: 48px
    color: var(--v-primary-base)
    border-color: var(--v-primary-base)
    span.v-chip
      letter-spacing: initial

.user-info
  background-color: white
  border-radius: 20px
  padding: 20px
  .user-name
    font-weight: bold
    font-size: 24px
  .user-desc
    border-bottom: 5px dotted var(--v-secondary-lighten2)

button.v-btn.follow-btn
  width: 180px
  height: 48px
  font-size: 16px
  font-weight: bold
</style>
