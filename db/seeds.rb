user = User.create(email: 'test@mail.com', password: '123123')

questions = Question.create([
  { body: 'What operator begins the function description?', title: 'js', author: user },
  { body: 'What command is used to create the table?', title: 'ruby', author: user },
  { body: 'Which tag is used to describe the first level header?', title: 'python', author: user }
])

answers = Answer.create([
  { correct: true, body: 'text 1', question_id: questions[0].id },
  { correct: true, body: 'text 2', question_id: questions[1].id },
  { correct: true, body: 'text 3', question_id: questions[2].id },
  { correct: true, body: 'text 4', question_id: questions[0].id },
  { correct: true, body: 'text 5', question_id: questions[1].id },
  { correct: true, body: 'text 6', question_id: questions[2].id }
])
