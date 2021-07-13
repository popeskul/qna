questions = Question.create([
  { body: 'What operator begins the function description?' },
  { body: 'What command is used to create the table?' },
  { body: 'Which tag is used to describe the first level header?' }
])

answers = Answer.create([
  { correct: true, title: 'text 1', question_id: questions[0].id },
  { correct: true, title: 'text 2', question_id: questions[1].id },
  { correct: true, title: 'text 3', question_id: questions[2].id },
  { correct: true, title: 'text 4', question_id: questions[0].id },
  { correct: true, title: 'text 5', question_id: questions[1].id },
  { correct: true, title: 'text 6', question_id: questions[2].id }
])
