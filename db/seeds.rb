# frozen_string_literal: true

require "faker"

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

puts "  - 👑 管理者 (github_id: 100001)"
puts "  - 👤 一般ユーザー (github_id: 100002)"


puts "📚 カテゴリを作成中..."

categories_data = [
  { name: "PHPの基礎と構文", chapter_number: 1, weight: 20.0 },
  { name: "関数と配列", chapter_number: 2, weight: 20.0 },
  { name: "オブジェクト指向", chapter_number: 3, weight: 25.0 },
  { name: "セキュリティとデータベース", chapter_number: 4, weight: 20.0 },
  { name: "Web技術とHTTP", chapter_number: 5, weight: 15.0 }
]

categories = categories_data.map do |data|
  Category.create!(data)
end


puts "📝 問題データを作成中..."

categories.each do |category|
  10.times do |i|
    dummy_code = <<~PHP
      <?php
      $#{Faker::Lorem.word} = "#{Faker::Lorem.word}";
      function #{Faker::Lorem.word}($arg) {
          return $arg * 2;
      }
      ?>
    PHP

    question = Question.create!(
      category: category,
      content: "【#{category.name}】問#{i + 1}\n#{Faker::Lorem.sentence(word_count: 10)}?\n\nコード例:\n\n```php\n#{dummy_code}\n```",
      explanation: "【解説】\n#{Faker::Lorem.paragraph(sentence_count: 3)}\n\n詳しくは公式ドキュメント「#{category.name}」の章を参照してください。",
      official_page: rand(1..500)
    )

    choices_data = [
      { content: "【正解】#{Faker::Lorem.sentence(word_count: 5)}", correct: true },
      { content: Faker::Lorem.sentence(word_count: 5), correct: false },
      { content: Faker::Lorem.sentence(word_count: 5), correct: false },
      { content: Faker::Lorem.sentence(word_count: 5), correct: false }
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

[admin_user, general_user].each do |user|
  user_label = user.admin? ? "👑 管理者" : "👤 一般ユーザー"
  puts "  - #{user_label} の履歴を作成しています..."

  5.times do |exam_index|
    exam = Exam.create!(
      user: user,
      completed_at: Time.current - exam_index.days
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
end

puts "✨ シードデータの作成が完了しました！"
