<template lang="pug">
  schedule(
    v-if="type == 'schedule'"
    :id="id"
    :text="text"
    :date="date"
    :scheduledDate="scheduledDate"
    :finishedDate="finishedDate"
  )

  plain-post(
    v-else
    :id="id"
    :text="text"
    :images="images"
    :date="date"
    :respondedComment="respondedComment"
  )
</template>

<script>
import PlainPost from './plain_post';
import Schedule from './schedule';

export default {
  name: 'post',
  props: {
    id: Number,
    type: String,
    text: String,
    images: Array,
    date: Date,
    scheduledDate: Date,
    finishedDate: Date,
    respondedComment: Object
  },
  components: {
    PlainPost,
    Schedule
  }
}
</script>

<style lang="sass" scoped>

</style>
