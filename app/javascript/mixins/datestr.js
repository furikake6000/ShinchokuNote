const dateFormatter = Intl.DateTimeFormat('ja-JP', {
  month: 'narrow',
  day: 'numeric' ,
  hour12: false,
  hour: '2-digit',
  minute: '2-digit'
});
const dateFormatterWithYear = Intl.DateTimeFormat('ja-JP', {
  year: 'numeric',
  month: 'narrow',
  day: 'numeric' ,
  hour12: false,
  hour: '2-digit',
  minute: '2-digit'
});

export default {
  methods: {
    dateStr(date) {
      if(date.getFullYear() != new Date().getFullYear()){
        return dateFormatterWithYear.format(date);
      }
      return dateFormatter.format(date);
    },
    dateStrWithoutYear(date) {
      return dateFormatter.format(date);
    }
  }
};
