<template lang="pug">
  .comment
    .caption.secondary--text(v-if="author") {{author.screenName}}さんより
    .comment-text {{text}}
    .d-flex.align-center
      template(v-if="responsePost")
        v-btn(v-if="responseEnabled" @click="hideResponse" text small color="secondary")
          v-icon(small) mdi-chevron-up
          span 返信を非表示
        v-btn(v-else @click="showResponse" text small color="secondary")
          v-icon(small) mdi-chevron-down
          span 返信を表示
      v-btn(v-else text small color="secondary")
        v-icon(small) mdi-reply
        span 返信
      v-btn(@click="toggleFavored" text small :color="favored ? 'primary' : 'secondary'")
        v-icon(small) mdi-star
        span お気に入り
      v-btn(@click="toggleMuted" v-on="on" text small :color="muted ? 'primary' : 'secondary'")
        v-icon(small) mdi-eye-off
        span ミュート
      v-dialog(v-model="deleteDialogEnabled" width="500")
          template(v-slot:activator="{ on }")
            v-btn(v-on="on" text color="secondary")
              v-icon(small) mdi-delete
              span 削除
          v-card
            v-card-title.headline コメントを削除します
            v-card-text
              span このコメントを削除します。
              br
              span.error--text.font-weight-bold 復元はできません。本当によろしいですか？
            v-card-actions
              v-spacer
              v-btn.font-weight-bold(@click="hideDeleteDialog" text color="secondary") キャンセル
              v-btn.font-weight-bold(text color="error") 削除する
      v-dialog(v-model="muteDialogEnabled" width="500")
        v-card
          v-card-title.headline 投稿者をブロックしますか？
          v-card-text
            p コメントをミュートしました。この投稿者をブロックしますか？
            p ブロックすると同じ投稿者からのコメントが今後届かなくなります。
            p （投稿者に気づかれることはありません。）
          v-card-actions
            v-spacer
            v-btn.font-weight-bold(@click="hideMuteDialog" text color="secondary") ブロックしない
            v-btn.font-weight-bold(text color="error") ブロックする
      span.caption.secondary--text.ml-auto {{ dateStr(date) }}
    .ml-4(v-if="responsePost && responseEnabled")
      span {{responsePost.text}}
      v-row
        v-col(
          v-for="(image, index) in responsePost.images"
          :key="image"
          cols="4"
        )
          v-img(
            :src="image"
            aspect-ratio="1"
            @click="showLightbox(index)"
          )
      .text-right.caption.secondary--text {{dateStr(responsePost.date)}}
      vue-easy-lightbox(
        v-if="responsePost.images"
        :visible="lightboxEnabled"
        :imgs="responsePost.images"
        :index="lightboxIndex"
        @hide="hideLightbox"
      )
</template>

<script>
import Vue from 'vue';
import Lightbox from 'vue-easy-lightbox';

Vue.use(Lightbox);

export default {
  name: 'comment',
  props: {
    id: Number,
    text: String,
    date: Date,
    favored: Boolean,
    muted: Boolean,
    author: Object,
    responsePost: Object
  },
  data: function() {
    return {
      lightboxEnabled: false,
      lightboxIndex: 0,
      responseEnabled: false,
      muteDialogEnabled: false,
      deleteDialogEnabled: false
    };
  },
  methods: {
    showLightbox(index) {
      this.lightboxEnabled = true;
      this.lightboxIndex = index;
    },
    hideLightbox() {
      this.lightboxEnabled = false;
    },
    showResponse() {
      this.responseEnabled = true;
    },
    hideResponse() {
      this.responseEnabled = false;
    },
    showMuteDialog() {
      this.muteDialogEnabled = true;
    },
    hideMuteDialog() {
      this.muteDialogEnabled = false;
    },
    hideDeleteDialog() {
      this.deleteDialogEnabled = false;
    },
    toggleFavored() {
      this.favored = !this.favored;
    },
    toggleMuted() {
      this.muted = !this.muted;
      if(this.muted) this.showMuteDialog();
    }
  }
};
</script>

<style lang="sass" scoped>
</style>
