<template lang="pug">
  .image-editor-gui
    #image_editor.d-flex.justify-center
    .ma-4.d-flex.justify-center
      v-btn(@click="undo" icon text large)
        v-icon mdi-undo
      v-btn(@click="redo" icon text large)
        v-icon mdi-redo
      v-btn(@click="reset" icon text large)
        v-icon mdi-restore
      v-icon.mx-2.secondary--text(large) mdi-power-on
      v-btn(icon text large)
        v-icon mdi-crop
      v-btn(icon text large)
        v-icon mdi-flip-horizontal
      v-btn(icon text large)
        v-icon mdi-tune
      v-icon.mx-2.secondary--text(large) mdi-power-on
      v-btn(icon text large color="success lighten-3")
        v-icon mdi-check
      v-btn(icon text large color="error lighten-3")
        v-icon mdi-close

</template>

<script>
import * as ImageEditor from "tui-image-editor";

export default {
  name: "image-editor",
  props: {
    image: String
  },
  data: () => {
    return {
      imageEditor: null
    }
  },
  methods: {
    loadImage(image) {
      this.imageEditor.loadImageFromURL(image, "image").then((result) =>{
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
}
</script>

<style lang="sass" scoped>
  .image-editor-gui
    width: 1000px
    height: 780px
    padding: 40px
    background-color: var(--v-secondary-darken3)
  #image_editor
    height: 640px
</style>