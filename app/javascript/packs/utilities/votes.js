$(document).on('turbolinks:load',() => {
    $('.btn-vote').on('ajax:success', (e) => {
        const [vote] = e.detail;

        $('.vote-result[data-vote-id="' + vote.name + '-' + vote.id + '"]').text(vote.evaluation);
    })
        .on('ajax:error', function(e) {
            const [errors] = e.detail;
            const errors_container = $('.flash');

            errors_container.contents().remove()

            $.each(errors, function(_, value) {
                errors_container.append(`<div class="alert alert-danger">${value}</div>`)
            })
        })
})
