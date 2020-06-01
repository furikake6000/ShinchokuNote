<template lang="pug">
  #image_editor
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
    this.imageEditor = new ImageEditor(document.querySelector('#image_editor'));
    this.loadImage(this.image);
  }
}
</script>

<style lang="sass" scoped>
  #image_editor
    width: 1000px
    height: 800px
    background-color: black
</style>