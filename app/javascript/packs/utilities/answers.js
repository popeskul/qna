$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('d-none');
    })
});

App.cable.subscriptions.create('AnswersChannel', {
    connected() {
        return this.perform("follow")
    },
    received: (data) => {
        $('.answers tbody').append(data)
    }
});

