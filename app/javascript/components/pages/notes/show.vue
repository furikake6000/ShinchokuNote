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
          .new-post-form
            .new-post-text-form
              textarea(placeholder="新しい進捗を投稿する...")
              .image-hint テキストエリアへの画像のドロップ・コピペが可能です
            .d-flex.align-center.mt-2
              v-btn(icon color="secondary")
                v-icon mdi-image
              v-tooltip(top)
                template(v-slot:activator="{ on }")
                  v-btn(icon color="secondary" v-on="on")
                    v-icon mdi-link
                span URLでリンク
              v-tooltip(top)
                template(v-slot:activator="{ on }")
                  v-btn(icon color="secondary" v-on="on")
                    v-icon mdi-calendar
                span スケジュールの追加
              span.secondary--text.subtitle-1.font-weight-bold.ml-auto.mr-4 0 / 1000
              v-btn(rounded color="primary").follow-btn 投稿する
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
              .text-center.secondary--text 最近のノート
              v-card.note-card.my-4
                .bgstr
                  v-icon mdi-note-text
                .note-card-content
                  v-card-title.headline
                    span.mr-2 test
                    .chips
                      v-chip(color="success" small).ml-1 完成
                      v-chip(color="secondary" small).ml-1
                        v-icon mdi-lock
                        span 自分のみ
                      v-chip(color="error" small).ml-1 R18
                  v-card-subtitle Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ...
                  v-card-actions
                    v-spacer
                    v-tooltip(top)
                      template(v-slot:activator="{ on }")
                        v-btn(text color="secondary" v-on="on")
                          v-icon mdi-star
                          span 10
                      span フォローする
              v-card.note-card.my-4
                .bgstr
                  v-icon mdi-note-text
                .note-card-content
                  v-img(
                    src="http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f97e59db7026b209deb6890df4bc5551512f79f5/blob"
                    height="200px"
                    gradient="to bottom, rgba(0, 0, 0, 0), rgba(0, 0, 0, .5)"
                  ).white--text.align-end
                    v-card-title.headline
                      span.mr-2 test
                      .chips
                        v-chip(color="error" small).ml-1 R18
                  v-card-subtitle Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ...
                  v-card-actions                
                    v-spacer
                    v-tooltip(top)
                      template(v-slot:activator="{ on }")
                        v-btn(text color="secondary" v-on="on")
                          v-icon mdi-star
                          span 10
                      span フォローする
              template(v-for="note in notes")
                note(v-bind="note").my-4
              .text-center.secondary--text リクエストボックス
              v-card.note-card.my-4
                .bgstr.request
                  v-icon mdi-email
                .note-card-content
                  v-card-title.headline
                    span.mr-2 test
                    .chips
                      v-chip(color="secondary" small).ml-2
                        v-icon mdi-lock
                        span フォロワーさんのみ
                  v-card-subtitle Lorem ipsum dolor sit amet...
                  v-card-actions                
                    v-spacer
                    v-tooltip(top)
                      template(v-slot:activator="{ on }")
                        v-btn(text color="secondary" v-on="on")
                          v-icon mdi-star
                          span 10
                      span フォローする
            v-btn(outlined block color="primary") マイページへ
</template>

<script>
import Note from '../../modules/note.vue'

export default {
  data: function () {
    return {
      notes: [
        {
          name: 'test',
          desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ...',
          url: '',
          watchUrl: '',
          stage: 'finished',
          viewStance: 'only_me',
          rating: 'restricted_18',
          watchersCount: 10
        }
      ]
    }
  },
  components: {
    Note
  }
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
    font-size: 3rem
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
    font-size: 1.5rem
  .user-desc
    border-bottom: 5px dotted var(--v-secondary-lighten2)

.new-post-form
  .new-post-text-form
    position: relative
    textarea
      width: 100%
      padding: 20px
      background-color: white
      border: 2px solid var(--v-secondary-lighten2)
      border-radius: 20px
      &::placeholder
        color: var(--v-secondary-lighten2)
        font-weight: bold
    .image-hint
      position: absolute
      right: 20px
      bottom: 20px
      color: var(--v-secondary-lighten2)
      font-weight: bold
      font-size: 0.8rem

.note-card
  position: relative
  overflow: hidden
  .bgstr
    position: absolute
    z-index: 0
    bottom: -80px
    right: -20px
    white-space: nowrap
    font-size: 14rem
    font-weight: bold
    transform: rotate(-30deg)
    color: var(--v-primary-lighten5)
    &.request
      color: var(--v-accent-lighten2)
    .v-icon
      font-size: unset
      color: unset
  .note-card-content
    position: relative
    z-index: 1

button.v-btn.follow-btn
  width: 12rem
  height: 3rem
  font-size: 1rem
  font-weight: bold

button.v-btn.follow-btn
  width: 8rem
  height: 2.5rem
  font-size: 1rem
  font-weight: bold
</style>
