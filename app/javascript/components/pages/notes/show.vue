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
            p.flex-grow-1 {{note.desc}}
            .flex-shrink-0.text-right.align-self-end
              .secondary--text.text--lighten-1.font-weight-bold {{dateStr(note.createdAt)}}作成 ({{elapsedDaysFrom(note.createdAt)}}日め)
      v-container
        v-row
          v-col.main-col(cols="8")
            post-form.post-form
            post-timeline(:posts="posts")
            comments(:comments="comments" :count="note.commentsCount")

          v-col.d-flex.flex-column(cols="4")
            user(v-bind="note.user")
            .flex-grow-1
              side-menu(v-bind="note")
    footer.grid-bg
      footer-links
</template>

<script>
import PostForm from '../../modules/posts/post_form.vue';
import PostTimeline from '../../modules/posts/post_timeline.vue';
import Comments from '../../modules/comments/comments.vue';
import FooterLinks from '../../modules/footer_links.vue';
import SideMenu from '../../modules/side_menu.vue';
import ShinchokuButton from '../../modules/shinchoku_dodeskas/shinchoku_button.vue';
import NoteBadges from '../../modules/notes/note_badges.vue';
import User from '../../modules/users/user.vue';
import icon from '../../../assets/images/icon.svg';

export default {
  data: function () {
    return {
      note: {},
      posts: [],
      comments: [],
      icon: icon
    };
  },
  mounted () {
    this.axios.get(`/api/v1/notes/${ this.$route.params.id }`).then(response => {
      this.note = this.deepCamelCase(response.data);
    });
    this.axios.get(`/api/v1/notes/${ this.$route.params.id }/posts`).then(response => {
      this.posts = this.deepCamelCase(response.data).posts;
    });
    this.axios.get(`/api/v1/notes/${ this.$route.params.id }/comments`).then(response => {
      this.comments = this.deepCamelCase(response.data).comments;
    });
  },
  methods: {
    elapsedDaysFrom(dateStr) {
      return Math.floor((Date.now() - Date.parse(dateStr)) / (1000 * 60 * 60 * 24));
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
};
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
