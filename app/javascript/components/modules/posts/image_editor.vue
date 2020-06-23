<template lang="pug">
  .image-editor-gui.elevation-8
    #image_editor.d-flex.justify-center.align-center
    .ma-4
      div(v-show="isCropping")
        .d-flex.justify-center.align-center
          v-btn(@click="setCropRatio(1)" text) 1:1
          v-btn(@click="setCropRatio(1.333333)" text) 4:3
          v-btn(@click="setCropRatio(1.777777)" text) 16:9
          v-icon.mx-2.secondary--text(large) mdi-power-on
          .text-center.mx-2
            v-btn(@click="applyCrop" icon text large)
              v-icon mdi-check
            .caption 適用
          .text-center.mx-2
            v-btn(@click="cancelCrop" icon text large)
              v-icon mdi-close
            .caption キャンセル
      div(v-show="flipModeEnabled")
        .d-flex.justify-center
          .text-center.mx-2
            v-btn(@click="flipX" icon text large)
              v-icon mdi-flip-horizontal
            .caption 水平
          .text-center.mx-2
            v-btn(@click="flipY" icon text large)
              v-icon mdi-flip-vertical
            .caption 垂直
          .text-center.mx-2
            v-btn(@click="resetFlip" icon text large)
              v-icon mdi-restore
            .caption リセット
          v-icon.mx-2.secondary--text(large) mdi-power-on
          .text-center.mx-2
            v-btn(@click="applyFlip" icon text large)
              v-icon mdi-check
            .caption 適用
          .text-center.mx-2
            v-btn(@click="cancelFlip" icon text large)
              v-icon mdi-close
            .caption キャンセル
      div(v-show="!isCropping && !flipModeEnabled")
        .d-flex.justify-center.align-center
          .text-center.mx-2
            v-btn(@click="undo" icon text large :disabled="imageEditor && imageEditor.isEmptyUndoStack()")
              v-icon mdi-undo
            .caption 元に戻す
          .text-center.mx-2
            v-btn(@click="redo" icon text large :disabled="imageEditor && imageEditor.isEmptyRedoStack()")
              v-icon mdi-redo
            .caption やり直し
          .text-center.mx-2
            v-btn(@click="reset" icon text large)
              v-icon mdi-restore
            .caption リセット
          v-icon.mx-2.secondary--text(large) mdi-power-on
          .text-center.mx-2
            v-btn(@click="startCrop" icon text large)
              v-icon mdi-crop
            .caption トリミング
          .text-center.mx-2
            v-btn(@click="startFlip" icon text large)
              v-icon mdi-flip-horizontal
            .caption 反転
          v-icon.mx-2.secondary--text(large) mdi-power-on
          .text-center.mx-2
            v-btn(@click="$emit('apply', imageEditor.toDataURL())" icon text large color="success lighten-3")
              v-icon mdi-check
            .caption.success--text.text--lighten-3 決定
          .text-center.mx-2
            v-btn(@click="$emit('cancel')" icon text large color="error lighten-3")
              v-icon mdi-close
            .caption.error--text.text--lighten-3 キャンセル
</template>

<script>
import * as ImageEditor from 'tui-image-editor';

export default {
  name: 'image-editor',
  props: {
    image: String
  },
  data: () => {
    return {
      imageEditor: null,
      flipModeEnabled: false
    };
  },
  computed: {
    isCropping() {
      if(!this.imageEditor) return false;
      return this.imageEditor.getDrawingMode() === 'CROPPER';
    }
  },
  methods: {
    loadImage(image) {
      this.imageEditor.loadImageFromURL(image, 'image').then(() =>{
        this.imageEditor.clearUndoStack();
      });
    },
    undo() {
      this.imageEditor.undo();
    },
    redo() {
      this.imageEditor.redo();
    },
    reset() {
      this.loadImage(this.image);
    },
    startCrop() {
      this.imageEditor.startDrawingMode('CROPPER');
    },
    applyCrop() {
      this.imageEditor.crop(this.imageEditor.getCropzoneRect()).then(() => {
        this.imageEditor.stopDrawingMode();
      });
    },
    cancelCrop() {
      this.imageEditor.stopDrawingMode();
    },
    setCropRatio(ratio) {
      this.imageEditor.setCropzoneRect(ratio);
    },
    startFlip() {
      this.flipModeEnabled = true;
    },
    flipX() {
      this.imageEditor.flipX();
    },
    flipY() {
      this.imageEditor.flipY();
    },
    resetFlip() {
      this.imageEditor.resetFlip();
    },
    applyFlip() {
      this.flipModeEnabled = false;
    },
    cancelFlip() {
      this.imageEditor.resetFlip();
      this.flipModeEnabled = false;
    }
  },
  watch: {
    image: function(newImage) {
      this.loadImage(newImage);
    }
  },
  mounted: function() {
    this.imageEditor = new ImageEditor(document.querySelector('#image_editor'), {
      cssMaxWidth: 960,
      cssMaxHeight: 640
    });
    this.loadImage(this.image);
  }
};
</script>

<style lang="sass" scoped>
  .image-editor-gui
    width: 1000px
    height: 780px
    padding: 40px
    background-color: var(--v-secondary-darken3)
    border-radius: 20px
  #image_editor
    height: 640px
</style>