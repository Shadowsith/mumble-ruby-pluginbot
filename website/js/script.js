// TODO need to handle this from ruby
$(document).ready(function () {
    Pluginbot.autoHeight($('textarea')[0]);
    Pluginbot.setDefaultValues();
    Pluginbot.registerEvents();
});

class Pluginbot {
    static autoHeight(elem) {
        if(elem !== undefined) {
            elem.style.height='auto';
            elem.style.height=elem.scrollHeight+'px';
        }
    }

    static setDefaultValues() {
        $("#newPwRow").hide();
    }

    static registerEvents() {
        $("#newPassword").change(function() {
            if ($(this).is(":checked")) {
                $("#newPwRow").show();
            } else {
                $("#newPwRow").hide();
            }
        });
    }
}
