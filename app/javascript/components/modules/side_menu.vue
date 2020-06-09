<template lang="pug">
  .side-menu
    .d-flex.flex-column.pa-4
      .icon.elevation-6(v-html="icon")
      v-btn.mt-4(fab color="secondary")
        v-icon mdi-star
      v-btn.mt-4(fab color="secondary")
        v-icon mdi-email

    .pa-4
      .mb-2.secondary--text.font-weight-bold このノートを共有
      v-text-field(:value="currentUrl" readonly filled rounded dense)
      .mt-n4.text-right
        v-tooltip(bottom)
          template(v-slot:activator="{ on }")
            v-btn(v-on="on" fab color="twitter" dark small)
              v-icon mdi-twitter
          span ツイート
        v-tooltip(bottom)
          template(v-slot:activator="{ on }")
            v-btn.ml-2(v-on="on" fab color="secondary" small)
              v-icon mdi-link-variant
          span URLをコピー
</template>

<script>
import icon from "../../assets/images/icon.svg"

export default {
  name: "side-menu",
  data: () => {
    return {
      icon: icon
    }
  },
  computed: {
    currentUrl() {
      return location.href;
    }
  }
}
</script>

<style lang="sass" scoped>
  .side-menu
    position: relative
  .icon
    background-color: white
    border-radius: 50%
    width: 72px
    height: 72px
    fill: #bf321d
</style>
