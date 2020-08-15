// (refs: https://qiita.com/mimaun/items/51a036037bdca85f8ad4)
import isObject from 'lodash.isobject';
import camelCase from 'lodash.camelcase';
import snakeCase from 'lodash.snakecase';

export default {
  methods: {
    deepMapKeys(obj, cb) {
      // 再帰終端
      if (!isObject(obj) || obj instanceof File) {
        return obj;
      }

      // Array
      if (Array.isArray(obj)) {
        return obj.map(val => {
          return this.deepMapKeys(val, cb); // 再帰処理
        });
      }

      // Object
      const processedEntries = Object.entries(obj).map(([key, val]) => [
        cb(key),
        this.deepMapKeys(val, cb) // 再帰処理
      ]);
      return Object.fromEntries(processedEntries);
    },
    deepCamelCase(obj) {
      return this.deepMapKeys(obj, camelCase);
    },
    deepSnakeCase(obj) {
      return this.deepMapKeys(obj, snakeCase);
    }
  }
};
