App.cable.subscriptions.create({ channel: "CommentsChannel", question_id: gon.question_id }, {
    connected() {
        return this.perform("follow")
    },
    received: (data) => {
        const type = data.comment.commentable_type.toLowerCase();
        const id = data.comment.commentable_id;

        if (type === 'question') {
            $('.question-comments-list').append(data.partial);
        } else {
            $(`.answer-comments-list[data-answer-comments-list=${id}]`).append(data.partial);
        }

        $('.new-comment #comment_body').val('');
    }
});
