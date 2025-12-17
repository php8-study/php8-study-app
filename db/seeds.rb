puts "🧹 既存のデータを削除中..."
ExamAnswer.destroy_all
ExamQuestion.destroy_all
Exam.destroy_all
QuestionChoice.destroy_all
Question.destroy_all
Category.destroy_all
User.destroy_all


puts "👤 ユーザーを作成中..."

admin_user = User.create!(
  github_id: 100_001,
  admin: true
)

general_user = User.create!(
  github_id: 100_002,
  admin: false
)

puts "  - 管理者 (github_id: 100001)"
puts "  - 一般ユーザー (github_id: 100002)"


puts "📚 カテゴリを作成中..."

categories_data = [
  { name: 'PHPの基礎と構文', chapter_number: 1, weight: 1.0 },
  { name: '関数と配列', chapter_number: 2, weight: 1.0 },
  { name: 'オブジェクト指向', chapter_number: 3, weight: 1.5 },
  { name: 'セキュリティとデータベース', chapter_number: 4, weight: 1.2 },
  { name: 'Web技術とHTTP', chapter_number: 5, weight: 0.8 }
]

categories = categories_data.map do |data|
  Category.create!(data)
end


puts "📝 問題データを作成中..."

categories.each do |category|
  10.times do |i|
    question = Question.create!(
      category: category,
      content: "【#{category.name}】に関する問題 #{i + 1}\nPHPにおいて、この挙動として正しいものはどれですか？\nサンプルコード:\n<?php echo 'Hello'; ?>",
      explanation: "これは解説文です。#{category.name}の重要なポイントは...です。\n公式マニュアルを参照してください。",
      official_page: rand(1..500)
    )


    choices_data = [
      { content: "これが正解の選択肢です。", correct: true },
      { content: "これは誤りの選択肢Aです。", correct: false },
      { content: "これは誤りの選択肢Bです。", correct: false },
      { content: "これは誤りの選択肢Cです。", correct: false }
    ]

    choices_data.shuffle.each do |c_data|
      QuestionChoice.create!(
        question: question,
        content: c_data[:content],
        correct: c_data[:correct]
      )
    end
  end
end

puts "📊 模擬試験の履歴データを作成中..."

3.times do |exam_index|
  exam = Exam.create!(
    user: general_user,
    completed_at: Time.current - exam_index.days # 今日、昨日、一昨日
  )

  selected_questions = Question.all.sample(10)

  selected_questions.each_with_index do |question, idx|
    exam_question = ExamQuestion.create!(
      exam: exam,
      question: question,
      position: idx + 1
    )

 
    correct_choice = question.question_choices.find_by(correct: true)
    incorrect_choices = question.question_choices.where(correct: false)
    
    picked_choice = if rand < 0.8
                      correct_choice
                    else
                      incorrect_choices.sample
                    end

    ExamAnswer.create!(
      exam_question: exam_question,
      question_choice: picked_choice
    )
  end
end

puts "✅ Seedデータの作成が完了しました！"
