<template lang="pug">
  .post-form
    .text-form(v-if="mode=='text'")
      textarea(v-model="newPost.text" placeholder="新しい進捗を投稿する...")
      .image-hint テキストエリアへの画像のドロップ・コピペが可能です
    .schedule-form(v-if="mode=='schedule'")
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
        // v-time-picker.ml-4(v-model="newSchedule.time" full-width format="24hr")
    .d-flex.align-center.mt-2
      v-btn(icon color="secondary")
        v-icon mdi-image
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
</template>

<script>
export default {
  name: 'post-form',
  data: function() {
    return {
      mode: 'text',
      newPost: {
        text: ""
      },
      newSchedule: {
        date: new Date().toISOString().substr(0, 10),
        time: "",
        text: ""
      }
    }
  },
  methods:  {
    setMode: function(mode) {
      this.mode = mode;
    }
  }
}
</script>

<style lang="sass" scoped>
  .text-form
    position: relative
    textarea
      width: 100%
      padding: 20px
      background-color: white
      border: 2px solid var(--v-secondary-lighten2)
      border-radius: 20px
      &::placeholder
        color: var(--v-secondary-lighten2)
        font-weight: bold
    .image-hint
      position: absolute
      right: 20px
      bottom: 20px
      color: var(--v-secondary-lighten2)
      font-weight: bold
      font-size: 0.8rem
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