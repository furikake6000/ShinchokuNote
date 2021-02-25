<template lang="pug">
  .shinchoku-button
    .icon(
      @click="sheet = true"
      v-html="icon"
      :class="classes"
      :style="`--size: ${size}`"
    ) 
    v-bottom-sheet(v-model="sheet")
      v-sheet(height="250px")
        v-btn(@click="sheet = false" text block color="secondary")
          v-icon mdi-close
          span.body-2 キャンセル
        v-row.stamps
          template(v-for="sticker in stickers")
            v-tooltip(top)
              template(v-slot:activator="{ on, attrs }")
                v-hover(v-slot:default="{ hover }")
                  v-col(:key="sticker.name" v-on="on")
                    v-img.ma-2(
                      :src="`/shinchoku_stamps/${sticker.name}.png`"
                      aspect-ratio="1" contain
                      :class="hover ? 'selected' : ''"
                    )
              span {{sticker.desc}}
</template>

<script>
import icon from '../../../assets/images/icon.svg';

export default {
  name: 'shinchoku-button',
  props: {
    noBackground: {
      type: Boolean,
      default: false,
    },
    color: {
      type: String,
      default: 'shinchoku'
    },
    size: {
      type: String,
      default: '64px'
    }
  },
  data: () => ({
    sheet: false,
    icon: icon,
    stickers: [
      {
        name: 'plain',
        desc: '進捗どうですか？'
      },
      {
        name: 'machimasu',
        desc: 'いつまでも待ちます。'
      },
      {
        name: 'otukare',
        desc: 'おつかれさま'
      },
      {
        name: 'ouen',
        desc: '応援してます！'
      },
      {
        name: 'suki',
        desc: 'スキ！'
      }
    ]
  }),
  computed: {
    classes() {
      let classes = [];
      classes.push(this.noBackground ? 'no-bg' : 'elevation-6');
      classes.push(`${this.color}--text`);
      return classes.join(' ');
    }
  }
};
</script>

<style lang="sass" scoped>
  .stamps
    max-width: 1080px
    margin-left: auto
    margin-right: auto

  .icon
    background-color: white
    border-radius: 50%
    width: var(--size)
    height: var(--size)
    line-height: calc(var(--size) / 2)
    fill: currentColor
    cursor: pointer
    &.no-bg
      background-color: rgba(0, 0, 0, 0)

  .v-image
    opacity: .6
    transition: opacity .3s ease 0s
    &.selected
      opacity: 1.0
</style>
