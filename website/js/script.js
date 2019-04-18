$(document).ready(function () {
    Pluginbot.autoHeight($('textarea')[0]);
});

class Pluginbot {
    static autoHeight(elem) {
        elem.style.height='auto';
        elem.style.height=elem.scrollHeight+'px';
    }
}
