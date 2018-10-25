// (ref: https://gist.githubusercontent.com/n0f/828c0c2935ee031c8b2b54697514542b/raw/170f0d972559fcb1e65922e86d47cc7250bb8ef4/jquery.text-with-lf.js )
// 改変として</div><div>を改行としてみなすようにしてある

(function ($) {
    var escapes = {
        '&': '&amp;',
        '<': '&lt;',
        '>': '&gt;',
        '"': '&quot;',
        "'": '&#39;'
    },
        escapeRegexp = /[&<>"']/g,
        hasEscapeRegexp = new RegExp(escapeRegexp.source),
        unescapes = {
            '&amp;': '&',
            '&lt;': '<',
            '&gt;': '>',
            '&quot;': '"',
            '&#39;': "'"
        },
        unescapeRegexp = /&(?:amp|lt|gt|quot|#39);/g,
        hasUnescapeRegexp = new RegExp(unescapeRegexp.source),
        stripRegExp = /<(?:.|\n)*?>/mg,
        hasStripRegexp = new RegExp(stripRegExp.source),
        nl2brRegexp = /([^>\r\n]?)(\r\n|\n\r|\r|\n)/g,
        hasNl2brRegexp = new RegExp(nl2brRegexp.source),
        br2nlRegexp = /<br\s*\/?>|<\/div><div>/mg,
        hasBr2nlRegexp = new RegExp(br2nlRegexp.source);

    $.fn.textWithLF = function (text) {
        var type = typeof text;

        return (type == 'undefined')
            ? htmlToText(this.html())
            : this.html((type == 'function')
                ? function (index, oldHtml) {
                    var result = text.call(this, index, htmlToText(oldHtml));
                    return (typeof result == 'undefined')
                        ? result
                        : textToHtml(result);
                } : textToHtml(text));
    };

    function textToHtml(text) {
        return nl2br(escape(toString(text)));
    }

    function htmlToText(html) {
        return unescape(strip(br2nl(html)));
    }

    function escape(string) {
        return replace(string, escapeRegexp, hasEscapeRegexp, function (match) {
            return escapes[match];
        });
    }

    function unescape(string) {
        return replace(string, unescapeRegexp, hasUnescapeRegexp, function (match) {
            return unescapes[match];
        });
    }

    function strip(html) {
        return replace(html, stripRegExp, hasStripRegexp, '');
    }

    function nl2br(string) {
        return replace(string, nl2brRegexp, hasNl2brRegexp, '$1<br>');
    }

    function br2nl(string) {
        return replace(string, br2nlRegexp, hasBr2nlRegexp, '\n');
    }

    function replace(string, regexp, hasRegexp, replacement) {
        return (string && hasRegexp.test(string))
            ? string.replace(regexp, replacement)
            : string;
    }

    function toString(value) {
        if (value == null) return '';
        if (typeof value == 'string') return value;
        if (Array.isArray(value)) return value.map(toString) + '';
        var result = value + '';
        return '0' == result && 1 / value == -(1 / 0) ? '-0' : result;
    }
})(jQuery);