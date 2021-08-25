$(document).on('turbolinks:load', function(){
    const answer = $('.answers');

    answer.on('click', '.edit-answer-link', function(e) {
        e.preventDefault();
        $(this).hide();
        const answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('d-none');
    });

    answer.on('click', '.button-answer-comment', function(e) {
        e.preventDefault();
        $(this).addClass('d-none');
        const answerId = $(this).data('answerId');
        $('form#Add-Answer-Comment-' + answerId ).removeClass('d-none');
    })
});

App.cable.subscriptions.create({ channel: "AnswersChannel", question_id: gon.question_id }, {
    connected() {
        return this.perform("follow")
    },
    received: (data) => $('.answers tbody').append(data.partial)
});

