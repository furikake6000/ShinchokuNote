<template lang="pug">
  .post-form
    .text-form(v-show="mode=='text'")
      .text-area
        textarea(
          v-model="newPost.text"
          placeholder="新しい進捗を投稿する..."
          @drop.prevent="dropImages"
        )
        .image-hint テキストエリアへの画像のドロップ・コピペが可能です
      .image-preview.d-flex.mt-2(v-if="newPost.images.length > 0")
        template(v-for="(image, index) in newPost.images")
          v-hover(v-slot:default="{ hover }")
            v-img.mr-2(
              @click="editImage(index)"
              :src="image"
              max-width="128px"
              height="128px"
            )
              .ma-1.d-flex.justify-space-between(v-if="hover")
                v-btn(@click="editImage(index)" x-small fab color="secondary darken-2")
                  v-icon mdi-image-edit
                v-btn(@click="deleteImage(index)" x-small fab color="secondary darken-2")
                  v-icon mdi-close
    .schedule-form(v-show="mode=='schedule'")
      v-text-field(label="スケジュール タイトル")
      p.font-weight-bold.mb-0 目標日時
      .d-flex
        v-menu(
          ref="dateDialog"
          :close-on-content-click="false"
          :return-value.sync="newSchedule.date"
          transition="scale-transition"
          offset-y
          min-width="290px"
        )
          template(v-slot:activator="{ on }")
            v-text-field.pt-0(
              v-model="newSchedule.date"
              prepend-icon="mdi-calendar"
              v-on="on"
            )
          v-date-picker(
            @input="$refs.dateDialog.save(newSchedule.date)"
            v-model="newSchedule.date"
            locale="ja-JP"
            :day-format="date => new Date(date).getDate()"
          )
        v-menu(
          ref="timeDialog"
          :close-on-content-click="false"
          :return-value.sync="newSchedule.time"
          transition="scale-transition"
          offset-y
          min-width="290px"
        )
          template(v-slot:activator="{ on }")
            v-text-field.pt-0(
              v-model="newSchedule.time"
              prepend-icon="mdi-clock"
              v-on="on"
            )
          v-time-picker(
            @click:minute="$refs.timeDialog.save(newSchedule.time)"
            v-model="newSchedule.time"
            format="24hr"
          )
    .d-flex.align-center.mt-2
      v-btn(@click="$refs.imageInput.click()" :disabled="mode!='text'" icon color="secondary")
        v-icon {{mode == "text" ? "mdi-image" : "mdi-image-off"}}
        input.d-none(
          ref="imageInput"
          multiple
          type="file"
          accept="image/jpeg, image/jpg, image/png, image/gif, image/bmp"
          @change="addImagesFromInput"
        )
      v-tooltip(top)
        template(v-slot:activator="{ on }")
          v-btn(@click="setMode('text')" icon :color="mode=='text'?'primary':'secondary'" v-on="on")
            v-icon mdi-pencil-plus
        span 新規投稿
      v-tooltip(top)
        template(v-slot:activator="{ on }")
          v-btn(@click="setMode('schedule')" icon :color="mode=='schedule'?'primary':'secondary'" v-on="on")
            v-icon mdi-calendar
        span スケジュールの作成
      template(v-if="mode=='text'")
        span.secondary--text.subtitle-1.font-weight-bold.ml-auto.mr-4 {{newPost.text.length}} / 1000
        v-btn(rounded color="primary").follow-btn.font-weight-bold 投稿する
      v-btn(v-if="mode=='schedule'" rounded color="primary").ml-auto.follow-btn.font-weight-bold スケジュールの作成
    v-overlay(:value="imageEditorEnabled")
      image-editor(
        :image="newPost.images[editingImageIndex]"
        @apply="applyEditingImage"
        @cancel="closeImageEditor"
      )
</template>

<script>
import loadImage from 'blueimp-load-image';
import ImageEditor from './image_editor.vue';

const MAX_IMAGE_SIZE = 1024 * 1024 * 1.5;

export default {
  name: 'post-form',
  data: function() {
    return {
      mode: 'text',
      newPost: {
        text: "",
        images: []
      },
      newSchedule: {
        date: new Date().toISOString().substr(0, 10),
        time: "",
        text: ""
      },
      imageEditorEnabled: false,
      editingImageIndex: null
    }
  },
  methods:  {
    setMode(mode) {
      this.mode = mode;
    },
    async addImages(files) {
      for (var i = 0; i < files.length; i++) {
        const type = files[i].type;
        if (type.indexOf('image/') < 0) continue;

        loadImage(
          files[i],
          async (c) => {
            this.newPost.images.push(c.toDataURL(type));
          },
          {
            canvas: true
          }
        )
      }
    },
    addImagesFromInput() {
      this.addImages(event.target.files);
      event.target.value="";
    },
    dropImages() {
      this.addImages(event.dataTransfer.files);
    },
    deleteImage(index) {
      this.newPost.images.splice(index, 1);
    },
    editImage(index) {
      this.editingImageIndex = index;
      this.imageEditorEnabled = true;
    },
    applyEditingImage(image) {
      this.newPost.images[this.editingImageIndex] = image;
      this.closeImageEditor();
    },
    closeImageEditor() {
      this.imageEditorEnabled = false;
    }
  },
  components: {
    ImageEditor
  }
}
</script>

<style lang="sass" scoped>
  .text-form
    padding: 20px
    background-color: white
    border: 2px solid var(--v-secondary-lighten2)
    border-radius: 20px
    .text-area
      position: relative
      textarea
        width: 100%
        margin-bottom: -5px
        &::placeholder
          color: var(--v-secondary-lighten2)
          font-weight: bold
      .image-hint
        position: absolute
        right: 10px
        bottom: 0
        color: var(--v-secondary-lighten2)
        font-weight: bold
        font-size: 0.8rem
    .image-preview
      overflow-x: auto
      .v-image
        cursor: pointer
  .schedule-form
    padding: 0 20px
    background-color: white
    border: 2px solid var(--v-secondary-lighten2)
    border-radius: 20px
</style>

<style lang="sass">
  .post-form .schedule-form .v-text-field label.v-label
    color: var(--v-secondary-lighten2)
    font-weight: bold
</style>