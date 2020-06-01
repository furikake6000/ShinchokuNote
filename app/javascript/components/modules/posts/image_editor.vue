<template lang="pug">
  .image-editor-gui
    #image_editor.d-flex.justify-center
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