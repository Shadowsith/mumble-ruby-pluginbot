$(document).ready(function () {
    Pluginbot.autoHeight($('textarea')[0]);
});

class Pluginbot {
    static autoHeight(elem) {
        if(elem !== undefined) {
            elem.style.height='auto';
            elem.style.height=elem.scrollHeight+'px';
        }
    }
}
