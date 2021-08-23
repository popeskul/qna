$(document).on('turbolinks:load', function(){
    const question = $('.question');

    question.on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        var question_id = $(this).data('questionId');
        $('form#edit-question-' + question_id).removeClass('d-none');
    });

    question.on('click', '.button-question-comment', function(e) {
        e.preventDefault();
        $(this).addClass('d-none');
        const questionId = $(this).data('questionId');
        $('form#Add-Question-Comment-' + questionId ).removeClass('d-none');
    })
});

App.cable.subscriptions.create('QuestionsChannel', {
    connected() {
        return this.perform("follow")
    },
    received: (data) => $('.questions tbody').append(data)
});
