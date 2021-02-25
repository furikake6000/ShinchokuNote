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
const timeFormatter = Intl.DateTimeFormat('ja-JP', {
  hour12: false,
  hour: '2-digit',
  minute: '2-digit'
});

export default {
  methods: {
    dateStr(dateStr) {
      const date = new Date(dateStr);
      if(date.getFullYear() != new Date().getFullYear()){
        return dateFormatterWithYear.format(date);
      }
      return dateFormatter.format(date);
    },
    dateStrWithoutYear(dateStr) {
      return dateFormatter.format(new Date(dateStr));
    },
    timeStr(dateStr) {
      return timeFormatter.format(new Date(dateStr));
    }
  }
};
