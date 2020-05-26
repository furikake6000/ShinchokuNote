<template lang="pug">
  .timeline
    .month-section.my-8(v-for="monthlyPosts in groupedPosts")
      .month-sign.small
        .month {{monthlyPosts.month}}
        .year / {{monthlyPosts.year}}
      template(v-for="dailyPosts in monthlyPosts.posts")
        .date {{monthlyPosts.month}}/{{dailyPosts.day}}
        post.ml-1.my-4(v-bind="post" v-for="post in dailyPosts.posts" :key="post.id")
      .month-sign
        .month {{monthlyPosts.month}}
        .year / {{monthlyPosts.year}}
        .month-en {{monthlyPosts.monthEn}}
</template>

<script>
import Post from './post.vue';

const monthFormatter = Intl.DateTimeFormat('en-US', { month: 'numeric' });
const monthEnFormatter = Intl.DateTimeFormat('en-US', { month: 'short' });

export default {
  name: 'post-timeline',
  props: {
    posts: Array
  },
  computed: {
    groupedPosts: function() {
      // postsを時間「降順」でソート
      this.posts.sort((a, b) => {
        return b.date.getTime() - a.date.getTime();
      });
      
      // postsを日毎にまとめ、さらに月毎にまとめる
      const groupedPosts = this.posts.reduce((groupedPosts, post) => {
        const year = post.date.getFullYear();
        const month = monthFormatter.format(post.date);
        const day = post.date.getDate();

        var monthElem = groupedPosts.find((el) => el.year == year && el.month == month);
        if (!monthElem) {
          monthElem = {
            year: year,
            month: month,
            monthEn: monthEnFormatter.format(post.date),
            posts: []
          };
          groupedPosts.push(monthElem);
        }
        var dayElem = monthElem.posts.find((el) => el.day == day);
        if (!dayElem) {
          dayElem = {
            day: day,
            posts: []
          };
          monthElem.posts.push(dayElem);
        }
        dayElem.posts.push(post);
        return groupedPosts;
      }, []);
      return groupedPosts;
    }
  },
  components: {
    Post
  }
}
</script>

<style lang="sass" scoped>
.month-section
  --timeline-color: var(--v-primary-lighten1)
  border-left: solid 20px var(--timeline-color)
  margin-left: 30px
  padding-left: 20px
  &::before
    content: ""
    position: relative
    top: -40px
    left: -50px
    border: 20px solid transparent
    border-bottom-color: var(--timeline-color)
  .month-sign
    display: flex
    align-items: baseline
    margin-left: -20px
    padding-left: 20px
    width: 400px
    line-height: 5.4rem
    height: 4.8rem
    border-radius: 0 999px 999px 0
    background-color: var(--timeline-color)
    color: white
    .month
      font-size: 5rem
      font-weight: bold
    .month-en
      position: relative
      top: -40px
      left: -110px
      color: rgba(255, 255, 255, .75)
      font-size: 1.8rem
    .year
      margin-left: 0.5rem
      font-size: 2.4rem
    &.small
      width: 250px
      line-height: 2.8rem
      height: 2.4rem
      .month
        font-size: 2.4rem
        font-weight: bold
      .year
        margin-left: 0.5rem
        font-size: 1.8rem
    + .date
      margin-top: 15px
  .date
    position: absolute
    width: 70px
    text-align: right
    left: -40px
    border-radius: 50%
    color: var(--timeline-color)
    line-height: 70px
    font-size: 1.5rem
    font-weight: bold
    &::after
      position: absolute
      top: 22px
      left: 77px
      content: ""
      width: 30px
      height: 30px
      border: solid 5px var(--timeline-color)
      border-radius: 50%
      background-color: white
</style>
