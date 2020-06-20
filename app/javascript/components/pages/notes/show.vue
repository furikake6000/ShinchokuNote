<template lang="pug">
  v-app
    main
      .cover.grid-bg
        v-container
          h1.name.mt-4.pb-3
            .d-flex.flex-column.flex-md-row
              .flex-grow-1.d-flex
                span {{note.name}}
                note-badges.ml-2(
                  :stage="(note.type == 'request_box' ? null : note.stage)"
                  :viewStance="note.viewStance"
                  :rating="note.rating"
                  outlined
                )
              .d-flex.align-center
                v-tooltip(bottom)
                  template(v-slot:activator="{ on }")
                    v-btn(v-on="on" icon large color="secondary")
                      v-icon mdi-star
                  span ウォッチ！
                v-tooltip(bottom)
                  template(v-slot:activator="{ on }")
                    v-btn(@click="$vuetify.goTo('.comments')" v-on="on" icon large color="secondary")
                      v-icon mdi-email
                  span コメント
                shinchoku-button.ml-2(noBackground=true color="secondary" size="36px")
          .d-flex.flex-column.flex-md-row.mt-4
            p {{note.desc}}
            .flex-shrink-0.text-right.align-self-end
              .secondary--text.text--lighten-1.font-weight-bold {{dateStr(note.createdAt)}}作成 ({{elapsedDaysFrom(note.createdAt)}}日め)
      v-container
        v-row
          v-col.main-col(cols="8")
            post-form.post-form
            post-timeline(:posts="posts")
            comments(:comments="comments" :count="commentsCount")

          v-col.d-flex.flex-column(cols="4")
            user(v-bind="user")
            .flex-grow-1
              side-menu
    footer.grid-bg
      footer-links
</template>

<script>
import PostForm from '../../modules/posts/post_form.vue'
import PostTimeline from '../../modules/posts/post_timeline.vue'
import Comments from '../../modules/comments/comments.vue'
import FooterLinks from '../../modules/footer_links.vue'
import SideMenu from '../../modules/side_menu.vue'
import ShinchokuButton from '../../modules/shinchoku_dodeskas/shinchoku_button.vue'
import NoteBadges from '../../modules/notes/note_badges.vue'
import User from '../../modules/users/user.vue'
import icon from "../../../assets/images/icon.svg"

const dateFormatter = Intl.DateTimeFormat('ja-JP', {
  month: 'narrow',
  day: 'numeric' ,
  hour12: false,
  hour: '2-digit',
  minute: '2-digit'
});
const dateFormatterWithYear = Intl.DateTimeFormat('ja-JP', {
  year: 'numeric',
  month: 'narrow',
  day: 'numeric' ,
  hour12: false,
  hour: '2-digit',
  minute: '2-digit'
});

export default {
  data: function () {
    return {
      note: {
        type: 'project',
        name: 'test',
        desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
        stage: 'finished',
        viewStance: 'only_me',
        rating: 'restricted_18',
        watchersCount: 3,
        shinchokuDodeskasCount: 15,
        commentsCount: 5,
        createdAt: new Date("1 Jan 2019 07:00:00 +0900")
      },
      user: {
        name: 'ふりかけ',
        desc: '',
        url: '/users/furikake555',
        thumbUrl: 'https://pbs.twimg.com/profile_images/1258916109442404353/I-NTF47_.jpg',
        twitterUrl: 'https://twitter.com/furikake555',
        twitterScreenName: 'furikake555',
        desc: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. https://example.com',
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
        requestBoxes: [
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
      },
      posts: [
        {
          id: 10,
          type: 'schedule',
          text: '未完のスケジュール',
          date: new Date("24 May 2020 13:57:00 +0900"),
          scheduledDate: new Date("31 May 2020 07:00:00 +0900")
        },
        {
          id: 9,
          type: 'schedule',
          text: '完了したスケジュール',
          date: new Date("24 May 2020 13:57:00 +0900"),
          scheduledDate: new Date("31 May 2020 07:00:00 +0900"),
          finishedDate: new Date("31 May 2020 09:23:00 +0900")
        },
        {
          id: 8,
          type: 'schedule',
          text: '時間切れのスケジュール',
          date: new Date("24 May 2020 13:57:00 +0900"),
          scheduledDate: new Date("11 May 2020 07:00:00 +0900")
        },
        {
          id: 6,
          text: 'a',
          images: [
            "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f97e59db7026b209deb6890df4bc5551512f79f5/blob"
          ],
          date: new Date("24 May 2020 13:57:00 +0900")
        },
        {
          id: 5,
          text: 'hogehogehogehoge~~~~~~~~~~~',
          date: new Date("24 May 2020 12:00:00 +0900")
        },
        {
          id: 7,
          text: 'poyopoyo',
          respondedComment: {
            from: 'furikake555',
            text: 'piyopiyo',
            date: new Date("23 May 2020 11:00:00 +0900")
          },
          date: new Date("24 May 2020 12:00:00 +0900")
        },
        {
          id: 4,
          text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
          date: new Date("21 May 2020 19:00:00 +0900")
        },
        {
          id: 3,
          text: 'poyo',
          images: [
            "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDUT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--efa9c0f7721c8f0adc8ce9d3b494cfd33efeff1e/blob",
            "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBDQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e1577d0c41acd953cfe105de0d9da9009c955ab6/blob"
          ],
          date: new Date("21 May 2020 12:00:00 +0900")
        },
        {
          id: 2,
          text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
          date: new Date("1 Dec 2019 19:00:00 +0900")
        },
        {
          id: 1,
          images: [
            "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--38a1a23da3d044d9c627bc246c838e29d660ec21/blob"
          ],
          respondedComment: {
            text: 'piyo',
            date: new Date("23 May 2020 11:00:00 +0900")
          },
          text: 'poyo',
          date: new Date("31 Dec 2019 12:00:00 +0900")
        },
      ],
      commentsCount: 5,
      comments: [
        {
          id: 4,
          text: 'コメント4',
          favored: false,
          muted: false,
          date: new Date("25 May 2020 14:00:00 +0900"),
          author: {
            screen_name: "ふりかけ",
            url: "/users/furikake555"
          },
          responsePost: {
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            date: new Date("21 May 2020 19:00:00 +0900")
          }
        },
        {
          id: 3,
          text: 'コメント3',
          favored: true,
          muted: false,
          date: new Date("24 May 2020 13:59:00 +0900"),
          responsePost: {
            text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
            images: [
              "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f97e59db7026b209deb6890df4bc5551512f79f5/blob",
              "http://localhost:3000/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--38a1a23da3d044d9c627bc246c838e29d660ec21/blob"
            ],
            date: new Date("13 Apr 2020 19:00:00 +0900")
          }
        },
        {
          id: 2,
          text: 'コメント2',
          favored: false,
          muted: false,
          date: new Date("24 May 2020 13:58:00 +0900")
        },
        {
          id: 1,
          text: 'コメント',
          favored: false,
          muted: false,
          date: new Date("24 May 2020 13:57:00 +0900"),
          author: {
            screen_name: "ふりかけ",
            url: "/users/furikake555"
          }
        },
        {
          id: 6,
          text: 'ミュートされたコメント',
          favored: false,
          muted: true,
          date: new Date("21 May 2020 13:57:00 +0900")
        },
        {
          id: 5,
          text: 'コメント5',
          favored: true,
          muted: false,
          date: new Date("24 Dec 2019 13:57:00 +0900")
        }
      ],
      icon: icon
    }
  },
  methods: {
    dateStr(date) {
      if(date.getFullYear() != new Date().getFullYear()){
        return dateFormatterWithYear.format(date);
      }
      return dateFormatter.format(date);
    },
    elapsedDaysFrom(date) {
      return Math.floor((Date.now() - date.getTime()) / (1000 * 60 * 60 * 24));
    }
  },
  components: {
    PostForm,
    PostTimeline,
    Comments,
    FooterLinks,
    SideMenu,
    ShinchokuButton,
    NoteBadges,
    User
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

.user-info
  background-color: white
  border-radius: 20px
  padding: 20px
  .user-name
    font-weight: bold
    font-size: 1.5rem
  .user-desc
    border-bottom: 5px dotted var(--v-secondary-lighten2)

.icon
  width: 48px
  height: 48px
  line-height: 24px
  fill: var(--v-secondary-base)

.main-col
  position: relative
  .post-form
    position: relative
    z-index: 101

.side-menu
  position: sticky
  top: 120px

footer
  background-color: white
  padding-top: 36px
  padding-bottom: 108px
</style>

<style lang="sass">
.cover h1.name span.v-chip
  letter-spacing: initial
</style>
