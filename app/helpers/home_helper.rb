# frozen_string_literal: true

module HomeHelper
  def landing_features
    [
      {
        title: "選べる2タイプの出題で効率的に勉強",
        items: ["全ての学習方法は無料", "問題は公式出題範囲から抜粋", "認定市販教材解説ページの案内有り"]
      },
      {
        title: "模擬試験タイプで実力をチェック",
        items: ["出題比率は公式と同様", "ランダムで変わる問題", "受験結果で成長を実感"]
      },
      {
        title: "フリー出題で学習",
        items: ["全問題からランダムで出題", "好きな時に学習", "好きな時間に終了"]
      }
    ]
  end
end
