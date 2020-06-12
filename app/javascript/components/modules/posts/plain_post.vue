<template lang="pug">
  .post
    .responded-comment.mb-2(v-if="respondedComment")
      .body-2.secondary--text {{respondedComment.from || "名無し"}}さんからのコメント
      .body-1 {{respondedComment.text}}
    .post-balloon-wrapper
      .post-balloon
        .bgstr
          .icon(v-html="icon")
        .content
          .float-right
            v-dialog(v-model="deleteDialogEnabled" width="500")
              template(v-slot:activator="{ on }")
                v-btn(v-on="on" text icon color="secondary lighten-1")
                  v-icon mdi-delete
              v-card
                v-card-title.headline 投稿を削除します
                v-card-text
                  span 投稿「{{trimmedText}}」を削除します。
                  br
                  span.error--text.font-weight-bold 復元はできません。本当によろしいですか？
                v-card-actions
                  v-spacer
                  v-btn.font-weight-bold(@click="hideDeleteDialog" text color="secondary") キャンセル
                  v-btn.font-weight-bold(text color="error") 削除する
          .body-2.secondary--text(v-if="respondedComment")
            v-icon.secondary--text.text--lighten-1 mdi-reply
            span コメントへの返信
          div(:class="textClass") {{text}}
          v-img.my-2(:src="image" v-for="(image, index) in images" max-height="600px" contain :key="image" @click="showLightbox(index)")
          .body-2.secondary--text {{timeStr}}
    vue-easy-lightbox(
      v-if="images"
      :visible="lightboxEnabled"
      :imgs="images"
      :index="lightboxIndex"
      @hide="hideLightbox"
    )
</template>

<script>
import Vue from 'vue';
import Lightbox from 'vue-easy-lightbox';
import icon from "../../../assets/images/icon.svg";
Vue.use(Lightbox);

const timeFormatter = Intl.DateTimeFormat('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' });

export default {
  name: 'plain-post',
  props: {
    id: Number,
    text: String,
    images: Array,
    date: Date,
    respondedComment: Object
  },
  data: function() {
    return {
      lightboxEnabled: false,
      lightboxIndex: 0,
      deleteDialogEnabled: false,
      icon: icon
    }
  },
  computed: {
    textClass: function() {
      if (this.text.length <= 30) return 'display-1';
      if (this.text.length <= 140) return 'headline';
      return 'body-1';
    },
    timeStr: function() {
      return timeFormatter.format(this.date);
    },
    trimmedText: function() {
      if(this.text.length <= 20) return this.text;
      return `${this.text.slice(0, 20)}...`;
    }
  },
  methods: {
    showLightbox: function(index) {
      this.lightboxEnabled = true;
      this.lightboxIndex = index;
    },
    hideLightbox: function() {
      this.lightboxEnabled = false;
    },
    hideDeleteDialog: function() {
      this.deleteDialogEnabled = false;
    }
  }
}
</script>

<style lang="sass" scoped>
  .responded-comment
    position: relative
    padding: 15px
    border-radius: 15px
    margin-right: 15px
    background-color: white
    border: solid 2px var(--v-secondary-lighten2)
    &::before
      content: ""
      position: absolute
      top: 20px
      right: -27px
      z-index: 2
      border: 14px solid transparent
      border-left-color: white
    &::after
      content: ""
      position: absolute
      top: 20px
      right: -30px
      z-index: 1
      border: 14px solid transparent
      border-left-color: var(--v-secondary-lighten2)
  .responded-comment + .post-balloon
    &::before
      content: ""
      position: absolute
      top: -27px
      left: 20px
      z-index: 2
      border: 14px solid transparent
      border-bottom-color: white
    &::after
      content: ""
      position: absolute
      top: -30px
      left: 20px
      z-index: 1
      border: 14px solid transparent
      border-bottom-color: var(--timeline-color)
  .post-balloon-wrapper
    position: relative
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
  .post-balloon
    position: relative
    padding: 15px
    border-radius: 15px
    overflow: hidden
  .v-image
    cursor: pointer
  .bgstr
    bottom: 100px
    right: 50px
    .icon
      width: 10rem
      height: 10rem
      fill: var(--v-primary-lighten5)
  .content
    position: relative
    z-index: 1
</style>
