questions = Question.create([
  { body: 'What operator begins the function description?', title: 'js' },
  { body: 'What command is used to create the table?', title: 'ruby' },
  { body: 'Which tag is used to describe the first level header?', title: 'python' }
])

answers = Answer.create([
  { correct: true, body: 'text 1', question_id: questions[0].id },
  { correct: true, body: 'text 2', question_id: questions[1].id },
  { correct: true, body: 'text 3', question_id: questions[2].id },
  { correct: true, body: 'text 4', question_id: questions[0].id },
  { correct: true, body: 'text 5', question_id: questions[1].id },
  { correct: true, body: 'text 6', question_id: questions[2].id }
])
