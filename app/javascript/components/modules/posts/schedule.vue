<template lang="pug">
  .schedule(:class="status")
    .bgstr.small
      v-icon {{statusIcon}}
    .content.d-flex.align-center
      v-icon(large @click="toggleFinished") {{statusCheckboxIcon}}
      .text-center.flex-grow-1
        .headline.font-weight-bold {{text}}
        .body-2.mt-2
          v-icon(small) mdi-clock-outline
          span {{dateStrWithoutYear(scheduledDate)}} まで
          span.ml-4(v-if="finishedDate")
            v-icon(small) mdi-check
            span {{dateStrWithoutYear(finishedDate)}} 完了
      v-menu(transition="scale-transition")
        template(v-slot:activator="{ on }")
          v-btn.align-self-start(v-on="on" text icon)
            v-icon mdi-dots-vertical
        v-list(dense)
          v-list-item
            v-list-item-icon
              v-icon mdi-pencil
            v-list-item-content
              v-list-item-title 編集する
          v-list-item(@click="showDeleteDialog")
            v-list-item-icon
              v-icon mdi-delete
            v-list-item-content
              v-list-item-title 削除する
    v-dialog(v-model="deleteDialogEnabled" width="500")
      v-card
        v-card-title.headline スケジュールを削除します
        v-card-text
          span スケジュール「{{text}}}」を削除します。
          br
          span.error--text.font-weight-bold 復元はできません。本当によろしいですか？
        v-card-actions
          v-spacer
          v-btn.font-weight-bold(@click="hideDeleteDialog" text color="secondary") キャンセル
          v-btn.font-weight-bold(text color="error") 削除する
</template>

<script>
const statusIcons = {
  'unfinished': 'mdi-clock-outline',
  'finished': 'mdi-check-circle',
  'outdated': 'mdi-clock-outline'
}
const statusCheckboxIcons = {
  'unfinished': 'mdi-checkbox-blank-outline',
  'finished': 'mdi-checkbox-marked-outline',
  'outdated': 'mdi-checkbox-blank-outline'
}

export default {
  name: 'post',
  props: {
    id: Number,
    text: String,
    date: Date,
    scheduledDate: Date,
    finishedDate: Date
  },
  data: function() {
    return {
      lightboxEnabled: false,
      lightboxIndex: 0,
      deleteDialogEnabled: false
    }
  },
  computed: {
    status: function() {
      if(this.finishedDate) return 'finished';
      if(this.scheduledDate > Date.now()) return 'unfinished';
      return 'outdated';
    },
    statusIcon: function() {
      return statusIcons[this.status];
    },
    statusCheckboxIcon: function() {
      return statusCheckboxIcons[this.status];
    }
  },
  methods: {
    toggleFinished: function(date) {
      if(this.status == 'finished'){
        this.finishedDate = null;
      }else{
        this.finishedDate = Date.now();
      }
    },
    showDeleteDialog: function() {
      this.deleteDialogEnabled = true;
    },
    hideDeleteDialog: function() {
      this.deleteDialogEnabled = false;
    }
  }
}
</script>

<style lang="sass" scoped>
  .schedule
    position: relative
    overflow: hidden
    padding: 15px
    border-radius: 15px
    word-wrap: break-word
    .content
      position: relative
      z-index: 1
    .v-icon
      color: unset
    color: var(--v-primary-darken1)
    background-color: var(--v-primary-lighten4)
    .bgstr
      color: var(--v-primary-lighten2)
    &.finished
      color: var(--v-success-darken1)
      background-color: var(--v-success-lighten3)
      .bgstr
        color: var(--v-success-lighten2)
    &.outdated
      color: var(--v-error-darken1)
      background-color: var(--v-error-lighten3)
      .bgstr
        color: var(--v-error-lighten2)
</style>
