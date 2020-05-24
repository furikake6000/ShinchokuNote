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
          .timeline.mb-8
            .month-section.small
              .month 5
              .year / 2020
            .date 5/24
            .post.my-4
              .display-1 a
              .body-2.secondary--text 13:57
            .post.my-4
              .display-1 hogehogehogehoge~~~~~~~~~~~
              .body-2.secondary--text 12:00
            .date 5/21
            .post.my-4
              .body-1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
              .body-2.secondary--text 19:00
            .post.my-4
              .display-1 poyo
              .body-2.secondary--text 12:00
            .post.my-4
              .headline 寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助
              .body-2.secondary--text 11:00
            .post.my-4
              .body-1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
              .body-2.secondary--text 19:00
            .post.my-4
              .display-1 poyo
              .body-2.secondary--text 12:00
            .post.my-4
              .headline 寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助
              .body-2.secondary--text 11:00
            .date 5/2
            .post.my-4
              .body-1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
              .body-2.secondary--text 19:00
            .date 5/1
            .post.my-4
              .display-1 poyo
              .body-2.secondary--text 12:00
            .post.my-4
              .headline 寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助
              .body-2.secondary--text 11:00
            .month-section
              .month 5
              .year / 2020
              .month-en May
          .timeline.mb-8
            .month-section.small
              .month 12
              .year / 2020
            .date 12/24
            .post.my-4
              .display-1 aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
              .body-2.secondary--text 13:57
            .post.my-4
              .display-1 hogehogehogehoge~~~~~~~~~~~
              .body-2.secondary--text 12:00
            .date 12/21
            .post.my-4
              .body-1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
              .body-2.secondary--text 19:00
            .post.my-4
              .display-1 poyo
              .body-2.secondary--text 12:00
            .post.my-4
              .headline 寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助
              .body-2.secondary--text 11:00
            .post.my-4
              .body-1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
              .body-2.secondary--text 19:00
            .post.my-4
              .display-1 poyo
              .body-2.secondary--text 12:00
            .post.my-4
              .headline 寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助
              .body-2.secondary--text 11:00
            .date 12/31
            .post.my-4
              .body-1 Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
              .body-2.secondary--text 19:00
            .post.my-4
              .display-1 poyo
              .body-2.secondary--text 12:00
            .post.my-4
              .headline 寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助
              .body-2.secondary--text 11:00
            .month-section
              .month 12
              .year / 2020
              .month-en Dec

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
              template(v-for="note in projects")
                note(v-bind="note").my-4
              .text-center.secondary--text リクエストボックス
              template(v-for="note in request_boxes")
                note(v-bind="note").my-4
            v-btn(outlined block color="primary") マイページへ
</template>

<script>
import Note from '../../modules/note.vue'

export default {
  data: function () {
    return {
      projects: [
        {
          type: 'project',
          name: 'test',
          desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
          url: '/notes/1',
          watchUrl: '',
          stage: 'finished',
          viewStance: 'only_me',
          rating: 'restricted_18',
          watchersCount: 10
        },
        {
          type: 'project',
          name: '寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助',
          desc: '寿限無寿限無五劫の擦り切れ海砂利水魚の水行末雲来末風来末食う寝る処に住む処やぶら小路の藪柑子パイポパイポパイポのシューリンガンシューリンガンのグーリンダイグーリンダイのポンポコピーのポンポコナーの長久命の長助',
          url: '/notes/1',
          watchUrl: '',
          thumbUrl: 'http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f97e59db7026b209deb6890df4bc5551512f79f5/blob',
          stage: 'in_progress',
          viewStance: 'everyone',
          rating: 'everyone',
          watchersCount: 10
        },
      ],
      request_boxes: [
        {
          type: 'request_box',
          name: 'testaaa',
          desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
          url: '/notes/1',
          watchUrl: '',
          stage: 'in_progress',
          viewStance: 'only_follower',
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

.timeline
  --timeline-color: var(--v-primary-base)
  border-left: solid 20px var(--timeline-color)
  margin-top: 20px
  margin-left: 30px
  padding-left: 20px
  &::before
    content: ""
    position: relative
    top: -40px
    left: -50px
    border: 20px solid transparent
    border-bottom-color: var(--timeline-color)
  .month-section
    display: flex
    align-items: baseline
    margin-left: -20px
    padding-left: 20px
    width: 400px
    line-height: 5.4rem
    height: 4.8rem
    border-radius: 0 999px 999px 0
    background-color: var(--timeline-color)
    color: white
    .month
      font-size: 5rem
      font-weight: bold
    .month-en
      position: relative
      top: -40px
      left: -110px
      color: rgba(255, 255, 255, .75)
      font-size: 1.8rem
    .year
      margin-left: 0.5rem
      font-size: 2.4rem
    &.small
      width: 250px
      line-height: 2.8rem
      height: 2.4rem
      .month
        font-size: 2.4rem
        font-weight: bold
      .year
        margin-left: 0.5rem
        font-size: 1.8rem
    + .date
      margin-top: 15px
  .date
    position: absolute
    width: 70px
    text-align: right
    left: -40px
    border-radius: 50%
    color: var(--timeline-color)
    line-height: 70px
    font-size: 1.5rem
    font-weight: bold
    &::after
      position: absolute
      top: 22px
      left: 77px
      content: ""
      width: 30px
      height: 30px
      border: solid 5px var(--timeline-color)
      border-radius: 50%
      background-color: white
    + .post
      margin-left: 5px
  .post
    position: relative
    padding: 15px
    border: solid 2px var(--timeline-color)
    border-radius: 15px
    background-color: white
    word-wrap: break-word
    &::before
      content: ""
      position: absolute
      top: 20px
      left: -27px
      z-index: 2
      border: 14px solid transparent
      border-right-color: white
    &::after
      content: ""
      position: absolute
      top: 20px
      left: -30px
      z-index: 1
      border: 14px solid transparent
      border-right-color: var(--timeline-color)

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
